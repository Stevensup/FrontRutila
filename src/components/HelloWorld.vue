<template>
  <div class="container">
    <div class="image-container">
      <img src="../assets/login.jpg" alt="Imagen descriptiva">
    </div>
    <div class="login">
      <h1>Iniciar sesión</h1>
      <form @submit.prevent="login">
        <label for="email">Email:</label>
        <input type="email" id="email" v-model="user.email" required>

        <label for="password">Contraseña:</label>
        <input type="password" id="password" v-model="user.userPassword" required>

        <button class="submit" type="submit">Iniciar sesión</button>
      </form>
      <p v-if="error" class="error-message">{{ error }}</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import swal from 'sweetalert';
export default {
  name: 'HelloWord',
  data() {
    return {
      user: {
        email: '',
        userPassword: ''
      },
      error: null
    };
  },
  methods: {
    async login() {
        try {
          const response = await axios.get(`http://localhost:8090/login?email=${encodeURIComponent(this.user.email)}&userPassword=${encodeURIComponent(this.user.userPassword)}`);
            console.log({ ...this.user, userPassword: '' });

            if (response.data.estado === 'autenticado') {
                this.$router.push('/Welcome');
                swal("Usuario autenticado", "El usuario está autenticado", "success");
            } else if (response.data.estado === 'bloqueado' || response.data.estado === 'fallido'){
                // Manejar el caso en que el usuario no esté autenticado
                console.log('Usuario no autenticado');
                throw new Error('Cagada');                
            }
        } catch (error) {
            // Manejar el error
            console.log(error);
            this.error = 'Cagada';
            swal("Error al iniciar sesión", "Cagada", "error");
        }
    }
}
}
</script>

<style scoped>
.submit {
  background-color: #0F5944;
  color: white;
  cursor: pointer;
}

.container {
  display: flex;
  justify-content: space-between;
  height: 80vh;
  overflow: hidden;
}

body,
html {
  margin: 0;
  padding: 0;
}

.image-container,
.login {
  height: auto;
  box-sizing: border-box;
  overflow: border-box;
}

.image-container {
  flex: 2;
  padding: 20px;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.login {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

form {
  display: flex;
  flex-direction: column;
}

label {
  margin-top: 10px;
}

input,
button {
  margin-top: 5px;
  padding: 10px;
  border: none;
  border-radius: 5px;
  border: 1px solid #0F5944;

}

button {
  background-color: #0F5944;
  color: white;
  cursor: pointer;
}

button:hover {
  background-color: #F28A2E;
}

/* Media query para pantallas con una anchura máxima de 600px */
@media (max-width: 600px) {
  .container {
    flex-direction: column;
    height: auto;
  }

  .image-container,
  .login {
    flex: none;
    width: 100%;
  }

  .image-container img {
    height: auto;
  }
}
</style>