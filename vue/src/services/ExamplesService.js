import axios from 'axios';

export default {

    getExampleById(exampleID) {
        return axios.get(`/examples/${exampleID}`)
    },
    getPrivateExampleById(exampleID) {
        return axios.get(`/examples/user/private/${exampleID}`)
    },
    getPendingExampleById(exampleID) {
        return axios.get(`/examples/user/pending/${exampleID}`)
    },
    getAllExamples(){
        return axios.get('/examples')
    },
    getDefaultExamples(){
        return axios.get('/examples/default')
    },
    getPendingExamples(){
        return axios.get('/examples/pending')
    },
    getLanguages(){
        return axios.get('/examples/languages')
    },
    getIntroId(language) {
        return axios.get(`/${language}`)
    },
    getTags(){
        return axios.get('/examples/tags')
    }, 
    getUserExamples(){
        return axios.get('/examples/user')
    },
    updateAttribution(example){
        return axios.put('/examples', example)
    },
    addPrivateExample(example){
        return axios.post('/examples/user',example)
    },
    deleteExample(id){
        return axios.post(`/delete/${id}`);
    },
    appendImageLink(example_id, imageLink){
        let body = {
            url: imageLink
        }
        return axios.put(`examples/image/${example_id}`, body)
    },
    submitExampleForApproval(id){
        return axios.put(`/examples/submit/${id}`)
    },
    redactExampleForApproval(id){
        return axios.put(`/examples/redact/${id}`)
    },
    approvePendingExample(id){
        return axios.put(`/examples/approve/${id}`)
    },
    declinePendingExample(id){
        return axios.put(`/examples/decline/${id}`)
    },
    makeDefault(id){
        return axios.put(`/examples/addDefault/${id}`)
    },
    removeDefault(id){
        return axios.put(`/examples/removeDefault/${id}`)
    },
    compileCode(data){
        return axios.post('compiler/run', data)
    }
}
