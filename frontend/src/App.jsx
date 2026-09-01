import { useEffect, useState } from "react";

function App() {
  const [mensagem, setMensagem] = useState("Carregando...");

  useEffect(() => {
       fetch(`${import.meta.env.VITE_API_URL}/api/hello`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Erro ao acessar a API");
        }

        return response.json();
      })
      .then((data) => {
        setMensagem(data.message);
      })
      .catch((error) => {
        console.error(error);
        setMensagem("Erro ao conectar com o backend");
      });
  }, []);

  return (
    <div>
      <h1>Frontend React</h1>
      <p>{mensagem}</p>
    </div>
  );
}

export default App;
