<template>
  <div v-on:click="sendTest">Send Email</div>
</template>

<script>
import emailService from '@/services/EmailService.js'
export default {
    name: 'email',
    methods:{
        sendTest(){
            let example = {
                user_id: 1
            }
            emailService.sendEmailsToSubscribers(example);
        }
    }
}
</script>


<style>

</style>