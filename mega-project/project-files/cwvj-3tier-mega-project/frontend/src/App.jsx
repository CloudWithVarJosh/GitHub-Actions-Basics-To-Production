import { useEffect, useState } from "react";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8080/api/v1";

function App() {
  const [users, setUsers] = useState([]);
  const [form, setForm] = useState({ name: "", email: "" });
  const [editingId, setEditingId] = useState(null);
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function loadUsers() {
    const response = await fetch(`${API_BASE_URL}/users`);
    if (!response.ok) throw new Error("Failed to load users");
    setUsers(await response.json());
  }

  useEffect(() => {
    loadUsers().catch(() => setMessage("Unable to connect to the backend"));
  }, []);

  function handleChange(event) {
    setForm({ ...form, [event.target.name]: event.target.value });
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setLoading(true);
    setMessage("");

    const url = editingId
      ? `${API_BASE_URL}/users/${editingId}`
      : `${API_BASE_URL}/users`;

    const method = editingId ? "PUT" : "POST";

    try {
      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form)
      });

      const data = response.status === 204 ? null : await response.json();

      if (!response.ok) {
        throw new Error(data?.error || "Request failed");
      }

      setForm({ name: "", email: "" });
      setEditingId(null);
      setMessage(editingId ? "User updated successfully" : "User added successfully");
      await loadUsers();
    } catch (error) {
      setMessage(error.message);
    } finally {
      setLoading(false);
    }
  }

  function startEdit(user) {
    setEditingId(user.id);
    setForm({ name: user.name, email: user.email });
    setMessage("");
  }

  function cancelEdit() {
    setEditingId(null);
    setForm({ name: "", email: "" });
  }

  async function deleteUser(id) {
    if (!window.confirm("Delete this user?")) return;

    try {
      const response = await fetch(`${API_BASE_URL}/users/${id}`, {
        method: "DELETE"
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data?.error || "Delete failed");
      }

      setMessage("User deleted successfully");
      await loadUsers();
    } catch (error) {
      setMessage(error.message);
    }
  }

  return (
    <main className="container">
      <header>
        <p className="eyebrow">Cloud With VarJosh</p>
        <h1>User Management</h1>
        <p className="subtitle">Three-tier application demo</p>
      </header>

      <section className="card">
        <h2>{editingId ? "Edit User" : "Add User"}</h2>

        <form onSubmit={handleSubmit}>
          <label>
            Name
            <input
              name="name"
              value={form.name}
              onChange={handleChange}
              placeholder="Varun Joshi"
              required
            />
          </label>

          <label>
            Email
            <input
              name="email"
              type="email"
              value={form.email}
              onChange={handleChange}
              placeholder="varun@example.com"
              required
            />
          </label>

          <div className="actions">
            <button type="submit" disabled={loading}>
              {loading ? "Saving..." : editingId ? "Update User" : "Add User"}
            </button>

            {editingId && (
              <button type="button" className="secondary" onClick={cancelEdit}>
                Cancel
              </button>
            )}
          </div>
        </form>

        {message && <p className="message">{message}</p>}
      </section>

      <section className="card">
        <div className="section-heading">
          <h2>Users</h2>
          <button className="secondary" onClick={() => loadUsers()}>
            Refresh
          </button>
        </div>

        {users.length === 0 ? (
          <p className="empty">No users found.</p>
        ) : (
          <div className="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => (
                  <tr key={user.id}>
                    <td>{user.name}</td>
                    <td>{user.email}</td>
                    <td>
                      <div className="row-actions">
                        <button className="secondary" onClick={() => startEdit(user)}>
                          Edit
                        </button>
                        <button className="danger" onClick={() => deleteUser(user.id)}>
                          Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </main>
  );
}

export default App;
