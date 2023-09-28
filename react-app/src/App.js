import React, { useEffect, useState } from 'react';

const App = () => {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch('http://localhost:4500/api/users')
      .then((response) => response.json())
      .then((data) => setUsers(data))
      .catch((error) => console.error('Error fetching users:', error));
  }, []);

  return (
    <div>
      <h1>Sample Users List</h1>
      <ul>
        {users.map((user) => (
          <li key={user.id}>
            {user.name}, Age: {user.age}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default App;
