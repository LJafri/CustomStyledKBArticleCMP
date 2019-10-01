import { LightningElement, track, wire, api } from 'lwc';
import getArticle from '@salesforce/apex/sbeccArticleController.getArticle';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import staticFiles from '@salesforce/resourceUrl/sbeccStaticFiles';
export default class SbeccArticle extends LightningElement {
    // User Inputted
    @api fontSize;
    @api fontWeight;
    @api objectName;
    @api titleField;
    @api dateField;
    @api bodyField;
    @api questionField;
    @api answerField;
    @api prettySkin;
    // Record Id
    @api recordId;
    // Frontend of Article
    @track articleTitle;
    @track articleDate;
    @track articleStyle;
    @track qA;
    // Other
    @track errors;
    @track objectFields;


    connectedCallback() {
        //Set base font size
        this.articleStyle = 'font-size: '+this.fontSize + ';font-weight: '+this.fontWeight+';'
        if(this.questionField != null || "") {
            this.qA = true;
        }
        //Get User Inputted Fields
        let articleFields = {
            titleField: this.titleField,
            dateField: this.dateField,
            bodyField: this.bodyField,
            questionField: this.questionField,
            answerField: this.answerField,
        }
        //Removes Nulls From the Object
        const removeEmptyFields = (obj) => 
            Object.entries(obj).forEach(([key, val]) => {
            if (val && typeof val === 'object') removeEmptyFields(val)
            else if (val == null || val === "" || val === undefined) delete obj[key]
        })
        removeEmptyFields(articleFields)
        this.objectFields = Object.values(articleFields)
    }
    renderedCallback() {
        Promise.all([
            //Load Prettify
            loadScript(this, staticFiles + '/prettify/prettify.js'),
            loadStyle(this, staticFiles + '/prettify/prettify.css'),
            loadStyle(this, staticFiles + '/prettify/skins/'+this.prettySkin+'.css')
        ])
        .then(() => {
            //Add Classes to Code/Pre Elements
            Array.prototype.slice.call(this.template.querySelectorAll('pre, code'))
            .forEach(function(element) {
                element.classList.add('prettyprint');
            });
            //PrettyPrint
            PR.prettyPrint()
        })
        .catch(error => {
            this.errors = error
        })
    }

    @wire(getArticle, { recordId: '$recordId', objectName: '$objectName', objectFields: '$objectFields'})
    wiredArticleTest({error, data}) {  
        if (data) {
            if(data[this.titleField] != null ){
                this.articleTitle = data[this.titleField];
            }
            if(data[this.dateField] != null ){
                this.articleDate = data[this.dateField];
            }
            if(data[this.bodyField] != null){
                this.template.querySelector('.sbecc-article_body').innerHTML = data[this.bodyField];
            }
            if(data[this.questionField] != null){
                this.template.querySelector('.sbecc-article_question').classList.remove('slds-hide');
                this.template.querySelector('.sbecc-article_question-content').innerHTML = data[this.questionField];
            }
            if(data[this.answerField] != null){
                this.template.querySelector('.sbecc-article_answer').classList.remove('slds-hide');
                this.template.querySelector('.sbecc-article_answer-content').innerHTML = data[this.answerField];
            }
        } else if(error) {
            this.errors = error
        }

    }

}
