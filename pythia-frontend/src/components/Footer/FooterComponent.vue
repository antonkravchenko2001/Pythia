<template>
    <div style="width: 100%;display: flex;justify-content: center;">
        <div class="footer">
            <span style="display:flex;justify-content:center;align-items:center;gap:10px;">
                <img src="../../../public/pythia-icon.svg" width='55' height='55' fill="none"/>
                <h2 class="title">Pythia</h2>
            </span>
            <ul class="no-bullets">
                <span class="list-title">Contact us</span>
                <div style="user-select:text;cursor:default;padding:3px;color:white;margin-top:10px;">{{email}}</div>
            </ul>
            <div class="social-media-container">
                <span class="list-title">Social media</span>
                <span class="social-media" style="margin-top:10px;">
                    <span style='cursor:pointer'>
                        <img src="../../../public/logos/telegram.svg" width='27' height='27' fill="none" @click="open('telegram')"/>
                    </span>
                    <span style='cursor:pointer'>
                        <img src="../../../public/logos/twitter.svg" width='27' height='27' fill="none" @click="open('twitter')"/>
                    </span>
                    <span style='cursor:pointer'>
                        <img src="../../../public/logos/linkedin.svg" width='27' height='27' fill="none" @click="open('linkedin')"/>
                    </span>
                    <span style='cursor:pointer'>
                        <img src="../../../public/logos/github.svg" width='27' height='27' fill="none" @click="open('github')"/>
                    </span>
                </span>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        data(){
            return {
                telegram: 'https://t.me/+861c-md9WcVkZmQy',
                github: 'https://github.com/antonkravchenko2001/Pythia',
                twitter: 'https://twitter.com/PythiaOfficial',
                linkedin: 'https://www.linkedin.com/company/pythia-company/about/?viewAsMember=true',
                email: 'support@pythia.company'
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
        justify-content: space-between;
        padding-bottom: 20px;
        font-family: 'Montserrat';
        width: 85%;
        font-weight: 350;
        font-size: 15px;
        color: #909090;
    }

    .no-bullets {
        list-style-type: none; /* Remove bullets */
        padding: 0; /* Remove padding */
        margin: 0; /* Remove margins */
    }

    li {
        padding: 3px;
        cursor: pointer;
    }

    li:hover {
        text-decoration: underline;
    }

    .social-media-container {
        display:flex;
        flex-direction: column;
    }

    .social-media {
        padding: 3px;
        display: grid;
        gap: 20px;
        grid-template-columns: repeat(4, 1fr);
    }

    .list-title {
        font-size: 15px;
        font-weight: 400;
        padding-left: 3px;
        padding-bottom: 5px;
        color:#4F6F98;
    }

    .title {
        color:#ffffff;
        font-size: 24px;
    }


    @media only screen and (max-width: 1000px) {
        .footer {
            width: 95%;
        }
    }

    @media only screen and (min-width: 1001px) {
        .footer {
            width: 85%;
        }
    }

    @media only screen and (min-width: 1200px) {
        .footer {
            width: 80%;
        }
    }





</style>