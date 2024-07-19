module.exports = {
    rapGuideSidebar: [
        // This is for all documentation from the RAP repo that should go in the `Guides` part of the menu. 
        {
            label: 'Contributor\'s guide',
            type: 'category',
            items: [
                'rap/installation-of-rap/README',
                'rap/installation-of-rap/deploying-ounl-rap3',
                'rap/installation-of-rap/deploying-rap3-with-azure-on-ubuntu',
                'rap/installation-of-rap/deploying-to-your-own-laptop',
                'rap/installation-of-rap/deployment-configuration',
                'rap/installation-of-rap/details',
                'rap/installation-of-rap/redeploying-rap3'
            ]
        },
        {
            label: 'How to deploy RAP',
            type: 'doc',
            id: 'rap/deployment-guide',
        },
    ],
    rapReferenceSidebar: [
        // This is for all documentation from the RAP repo that should go in the `Reference material` part of the menu. 
        {
            label: 'Deployment of RAP',
            type: 'doc',
            id: 'rap/rap-deployment',
        },
        {
            label: 'Monitoring RAP',
            type: 'doc',
            id: 'rap/monitoring-rap-in-production',
        }
    ],
};