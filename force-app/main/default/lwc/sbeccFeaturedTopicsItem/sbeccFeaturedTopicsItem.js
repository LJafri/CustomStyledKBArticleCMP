import { LightningElement, wire, api, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class SbeccFeaturedTopicsItem extends LightningElement {
    @api topic;
    @api childTopics;

    @api first;
    @api last;
    
    @api itemSettings;
    @track topicLink;
    @track imageStyle;
    @track showIcon;
    @wire(CurrentPageReference) currentPageReference;

    //Workaround until NavigationMixin supports topic pages?
    connectedCallback(){
        this.topicLink = 'https://' + window.location.host + '/s/' + this.itemSettings.topicSlug + this.topic.id
        this.showIcon = this.itemSettings.showIcon;
        if(this.itemSettings.showIcon === false){
            if (this.itemSettings.imageSource === 'Featured') {
                this.imageStyle = "background: url('"+ this.topic.topic.images.featuredImageUrl+"');background-repeat:no-repeat;background-size:cover;background-position: center;"
            } else { 
                this.imageStyle = "background: url('"+ this.topic.topic.images.coverImageUrl+"');background-repeat:no-repeat;background-size:cover;background-position: center;"
            }
        }
    }
    renderedCallback() {
        
    }
}
