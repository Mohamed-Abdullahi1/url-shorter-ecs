import { useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [url, setUrl] = useState("");
  const [shortUrl, setShortUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();

    setLoading(true);
    setError("");
    setShortUrl("");

    try {
      const response = await axios.post("/shorten", { url });

      console.log("API Response:", response.data);

      setShortUrl(response.data.short_url);
    } catch (err) {
      console.error("Shorten request failed:", err);

      if (err.response) {
        console.error("Status:", err.response.status);
        console.error("Response:", err.response.data);
      } else if (err.request) {
        console.error("No response received:", err.request);
      } else {
        console.error("Error:", err.message);
      }

      setError("Unable to shorten the URL. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(shortUrl);
    } catch (err) {
      console.error("Failed to copy URL:", err);
    }
  };

  return (
    <main className="page">
      <section className="hero">
        <p className="eyebrow">URL Shortening Platform</p>

        <h1>Create shorter links in seconds.</h1>

        <p className="subtitle">
          Create and share shortened URLs instantly, powered by Amazon ECS
          Fargate, Terraform and GitHub Actions.
        </p>
      </section>

      <section className="card">
        <form onSubmit={handleSubmit}>
          <label htmlFor="url">Paste your long URL</label>

          <div className="form-row">
            <input
              id="url"
              type="url"
              placeholder="https://example.com/very-long-link"
              value={url}
              onChange={(event) => setUrl(event.target.value)}
              required
            />

            <button type="submit" disabled={loading}>
              {loading ? "Shortening..." : "Shorten URL"}
            </button>
          </div>
        </form>

        {error && <p className="message error">{error}</p>}

        {shortUrl && (
          <div className="result">
            <div>
              <p className="result-label">Your shortened URL</p>

              <a href={shortUrl} target="_blank" rel="noreferrer">
                {shortUrl}
              </a>
            </div>

            <button
              className="copy-button"
              type="button"
              onClick={handleCopy}
            >
              Copy
            </button>
          </div>
        )}
      </section>

      <footer>
        Powered by React • FastAPI • Amazon ECS • Terraform
      </footer>
    </main>
  );
}

export default App;
