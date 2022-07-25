<template>
    <div class="footer">
        <span style="display:flex;justify-content:center;align-items:center">
            <img src="../../../public/pythia-icon.svg" width='120' height='100' fill="none"/>
            <h1 class="title">Pythia</h1>
        </span>
        <ul class="no-bullets">
            <span class="list-title">Email</span>
            <div style="user-select:text;cursor:default;padding:3px">antonkrvchnk57@gmail.com</div>
        </ul>
        <ul class="no-bullets">
            <span class="list-title">Social media</span>
            <li @click="open('telegram')">Telegram</li>
            <li @click="open('twitter')">Twitter</li>
            <li @click="open('linkedIn')">LinkedIn</li>
        </ul>
        <ul class="no-bullets">
            <span class="list-title">Other</span>
            <li @click="open('github')">GitHub</li>
        </ul>
    </div>
</template>

<script>
    export default {
        data(){
            return {
                telegram: 'https://t.me/+861c-md9WcVkZmQy',
                github: 'https://github.com/antonkravchenko2001/Pythia',
                twitter: 'https://twitter.com/PythiaCompany',
                linkedIn: 'https://www.linkedin.com/company/pythia-company/about/?viewAsMember=true',
            }
        },
        methods: {
            open(path){
                window.open(this[path])
            }
        }
    }
</script>

<style scoped>
    .footer {
        display:flex;
        justify-content: center;
        gap: 10%;
        max-width: max-content;
        min-width: 100%;
        padding-top: 10%;
        padding-bottom: 5%;
        font-family: 'Montserrat';
        font-weight: 350;
        font-size: 12px;
        color: #909090;
    }

    .no-bullets {
        list-style-type: none; /* Remove bullets */
        padding: 0; /* Remove padding */
        margin: 0; /* Remove margins */
    }

    li {
        padding: 3px;
    }

    li:hover {
        text-decoration: underline;
    }

    .list-title {
        font-size: 14px;
        font-weight: 400;
        padding-left: 3px;
        padding-bottom: 5px;
        color:#ffffff;
    }

    .title {
        color:#574eb8;
    }
</style>