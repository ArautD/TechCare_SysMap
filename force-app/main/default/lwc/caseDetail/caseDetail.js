import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, refreshApex } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import reopenCase from '@salesforce/apex/CaseRequestController.reopenCase';

const FIELDS = ['Case_Request__c.SLA_Deadline__c', 'Case_Request__c.Status__c'];

export default class CaseDetail extends LightningElement {
    @api recordId;
    @track slaCountdown;
    error;

    wiredRecord;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCase(result) {
        this.wiredRecord = result.data ? result : undefined;;
        const { error, data } = result;

        if (data) {
            const deadline = new Date(data.fields.SLA_Deadline__c.value);
            this.calculateCountdown(deadline);
            this.error = null;
        } else if (error) {
            this.error = 'Erro ao carregar SLA';
            this.showToast('Erro', this.error, 'error');
        }
    }

async handleReopen() {
    try {
        await reopenCase({ caseId: this.recordId });
        this.error = null;

        setTimeout(() => {location.reload();}, 500); // Aguarda meio segundo e recarrega a página
    } catch (e) {
        this.error = e.body?.message || e.message || 'Erro ao reabrir caso';
        this.showToast('Erro', this.error, 'error');
    }
}



    calculateCountdown(deadline) {
        const now = new Date();
        const diff = deadline - now;
        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

        this.slaCountdown = `${days} dias e ${hours} horas restantes`;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant,
            })
        );
    }
}