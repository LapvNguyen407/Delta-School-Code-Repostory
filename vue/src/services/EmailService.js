import axios from 'axios';

export default {
    getUsername(id) {
        return axios.get(`username/${id}`);
    },
    getSubscriberEmails(id) {
        return axios.get(`subscribers/${id}`);
    },
    getSubscribers() {
        return axios.get('/subscriptions');
    },
    subscribe(id){
        return axios.post(`subscribe/${id}`)
    },
    unsubscribe(id){
        return axios.post(`unsubscribe/${id}`)
    },
    sendTestEmail() {
        let requestBody = {
            "service_id": "service_rd9qb6u",
            "template_id": "template_qj7qeif",
            "user_id": "3KV4ZiK-22FdEE9G7",
            "template_params": {
                "from_name": "Lap phd",
                "message": "<html><body>This is the message body</body></html>",
                "subscribers": ["justinthomasdecker@gmail.com", "deltaschoolsTE@gmail.com"]
            }
        }
        return axios.post('https://api.emailjs.com/api/v1.0/email/send', requestBody)
    },
    sendEmailsToSubscribers(example) {
        let fromUser = "";
        this.getUsername(example.userId).then(response => {
            fromUser = response.data

            this.getSubscriberEmails(example.userId).then(response => {
                let emailAddresses = response.data
                if (emailAddresses.length != 0) {
                    let requestBody = {
                        "service_id": "service_rd9qb6u",
                        "template_id": "template_qj7qeif",
                        "user_id": "3KV4ZiK-22FdEE9G7",
                        "template_params": {
                            "from_name": fromUser,
                            "example_title" : example.title,
                            "link": "http://localhost:8081/example/"+example.example_id,
                            "subscribers": emailAddresses
                        }
                    }
                    axios.post('https://api.emailjs.com/api/v1.0/email/send', requestBody)

                }
            })
        });



    }
}