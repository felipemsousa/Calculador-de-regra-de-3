from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route("/", methods=['GET'])
def hello_world():
    try:
        return render_template('index.html')
    except Exception as e:
        return jsonify({"error": f"Erro ao renderizar a pagina: {str(e)}"}), 500

@app.route("/calcular", methods=['POST'])
def calcular_regra_3():
    # Recebe os dados em formato JSON
    data = request.get_json()

    # Pega os valores de a, b, c
    a = data.get('a')
    b = data.get('b')
    c = data.get('c')

    # Verifica se todos os valores foram enviados
    if not all([a, b, c]):
        return jsonify({'error': 'Faltam parametros'}), 400

    try:
        # Faz a regra de 3 para calcular X
        x = round((b * c) / a, 2)
    except Exception as e:
        # Se ocorrer algum erro, retorna 500 (Erro interno)
        return jsonify({'error': f'Erro ao calcular: {str(e)}'}), 500

    # Retorna a resposta em JSON com status 200 (sucesso)
    return jsonify({'x': x}), 200  # 200 OK

@app.route("/health", methods=['GET'])
def health_check():
    try:
        # Se a verificação for bem-sucedida
        return jsonify({
            "status": "ok",
            "message": "Servico UP"
        }), 200
    except Exception as e:
        # Se algo falhar na verificação
        return jsonify({
            "status": "error",
            "message": f"Falha ao verificar: {str(e)}"
        }), 500

if __name__ == "__main__":
    app.run(debug=True)