declare global {
  interface Window {
    env: any;
  }
}


export const environment = {
  production: true,
 //BACKEND_HOST: window['env']['REMOTE_HOST'] || 'http://localhost:8084'
  BACKEND_HOST: ''

};
