import { LightningElement, api, wire, track } from 'lwc';
import getTopics from '@salesforce/apex/sbeccTopicController.getTopics';

export default class SbeccFeaturedTopics extends LightningElement {
    @api title;
    @api networkName;

    @api topicType;
    @api topicSlug;
    @api showIcons;

    @api childTopics;
    @api iconLocation;
    @api imageStyle;
    @api imageSource;
    
    @api textAlignment;
    @api topicDesc;
    @api backGround;
    @api fgColor;

    @api recordId;
    @api topicId;

    @track topicClass;
    @track imageStyle;
    @track showIcon;
    
    @track topics;
    @track errors;
    
    @track topicsNew;
    @track errorsNew;

    @track itemSettings;

    connectedCallback() {
        let desc;
        let showIcon;
        if (this.topicId === undefined) {
            this.topicId = 'NA'
        }
        //Lowercase Datasource Values
        this.textAlignment = this.textAlignment.toLowerCase();
        this.iconLocation = this.iconLocation.toLowerCase();
        this.backGround = this.backGround.toLowerCase();
        this.fgColor = this.fgColor.toLowerCase();
        this.imageStyle = this.imageStyle.toLowerCase();
        if(this.topicType === 'Child') {
            this.childTopics = true
        } else (
            this.childTopics = false
        )
        //Booleaning
        desc = this.topicDesc === 'true';
        if(this.imageStyle === 'fill'){
            showIcon = false;
        } else {
            showIcon = true;
        }
        this.itemSettings = {
            topicDesc: desc,
            topicSlug: this.topicSlug,
            showIcon: showIcon,
            imageSource: this.imageSource,
            itemClass: 'sbecc-featured-topics__item sbecc-featured-topics__item_icon-' + this.iconLocation + ' slds-text-align_'+this.textAlignment + ' sbecc-featured-topics__item_bg-'+this.backGround + ' sbecc-featured-topics__item_fg-'+this.fgColor
        };
    }

    @wire(getTopics, { networkName: '$networkName', topicType: '$topicType', topicId: '$topicId'})
    wiredTopics({ error, data }) {
        if (data) {
            this.topics = data;
            console.log('works' + data)
            this.errors = null;
        } else {
            this.topics = null;
            console.log('bork ' + error)
            this.errors = error;
        }
    }
}
