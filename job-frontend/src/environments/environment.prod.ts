declare global {
  interface Window {
    env: any;
  }
}


export const environment = {
  production: true,
  //BACKEND_HOST: window['env']['backendUrl'] || 'http://localhost:8084'
  BACKEND_HOST:  '/api'
 
};
