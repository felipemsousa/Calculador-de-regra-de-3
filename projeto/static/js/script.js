const form = document.getElementById('calculatorForm');
const calculateBtn = document.getElementById('calculateBtn');
const btnText = document.getElementById('btnText');
const resultDiv = document.getElementById('result');
const errorDiv = document.getElementById('error');
const clearBtn = document.getElementById('clearBtn');

// Elementos dos campos de entrada
const valorA = document.getElementById('valorA');
const valorB = document.getElementById('valorB');
const valorC = document.getElementById('valorC');

// Elementos para mostrar resultados
const resultValue = document.getElementById('resultValue');
const resultFormula = document.getElementById('resultFormula');
const resultCalculation = document.getElementById('resultCalculation');
const errorMessage = document.getElementById('errorMessage');

// Função para esconder resultados e erros
function hideResults() {
    resultDiv.classList.remove('show');
    errorDiv.classList.remove('show');
}

// Função para mostrar erro
function showError(message) {
    hideResults();
    errorMessage.textContent = message;
    errorDiv.classList.add('show');
}

// Função para mostrar resultado
function showResult(data) {
    hideResults();
    resultValue.textContent = data.x;
    resultFormula.textContent = data.formula;
    resultCalculation.textContent = data.calculo;
    resultDiv.classList.add('show');
}

// Função para definir estado de carregamento
function setLoading(isLoading) {
    calculateBtn.disabled = isLoading;
    if (isLoading) {
        btnText.innerHTML = '<span class="loading"></span>Calculando...';
    } else {
        btnText.textContent = 'Calcular X';
    }
}

// Event listener para o formulário
form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const a = parseFloat(valorA.value);
    const b = parseFloat(valorB.value);
    const c = parseFloat(valorC.value);

    // Validações básicas no frontend
    if (isNaN(a) || isNaN(b) || isNaN(c)) {
        showError('Por favor, preencha todos os campos com valores válidos.');
        return;
    }

    if (a === 0) {
        showError('O valor A não pode ser zero.');
        return;
    }

    if (b === 0) {
        showError('O valor B não pode ser zero.');
        return;
    }

    setLoading(true);

    try {
        const response = await fetch('/calcular', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({
                a: a,
                b: b,
                c: c
            })
        });

        const data = await response.json();

        if (response.ok) {
            showResult(data);
        } else {
            // Lidar com erros específicos do backend
            if (data.error) {
                showError(data.error);
            } else if (data.a || data.b || data.c) {
                // Erros de validação dos campos
                const errors = [];
                if (data.a) errors.push(`A: ${data.a.join(', ')}`);
                if (data.b) errors.push(`B: ${data.b.join(', ')}`);
                if (data.c) errors.push(`C: ${data.c.join(', ')}`);
                showError(`Erros de validação: ${errors.join('; ')}`);
            } else {
                showError('Erro desconhecido no cálculo.');
            }
        }
    } catch (error) {
        console.error('Erro na requisição:', error);
        showError('Erro de conexão. Verifique sua internet e tente novamente.');
    } finally {
        setLoading(false);
    }
});

// Event listener para limpar campos
clearBtn.addEventListener('click', () => {
    form.reset();
    hideResults();
    valorA.focus();
});

// Função para obter CSRF token
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Adicionar animações nos campos de entrada
[valorA, valorB, valorC].forEach(input => {
    input.addEventListener('input', hideResults);

    input.addEventListener('focus', (e) => {
        e.target.style.transform = 'translateY(-1px)';
    });

    input.addEventListener('blur', (e) => {
        e.target.style.transform = 'translateY(0)';
    });
});

// Focar no primeiro campo ao carregar a página
window.addEventListener('load', () => {
    valorA.focus();
});