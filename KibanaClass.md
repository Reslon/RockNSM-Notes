# Kibana class Saturday

### What is Kibana
- Web UI for Elastic Search
- Visualizations of data
- Data Search

### Data Visualizations
- Data as images
- live update
- Why visualize?
- Allows graphs of data to show whats happening in a more readable Information

### Licensed Featured
- Enhanced security options(PKI, authentication, etc)
-

### Kibana setup


### Management Settings
- Index Management shows stats for elasticsearch and related  
- Life cycle management shows current policies
- Rollup manages space used
- Snapshot Repositories shows snapshots, and where snapshots are to be stored, and make new ones.  
- License Management is for managing licenses  
- Upgrade Assistant is future feature to assist in upgrading
- Index Pattern is for telling Kibana what indices to search in.  
- Saved objects is for modifying, restoring, and saving Kibana objects. Can export Visualizations
- Spaces is to manage Kibana spaces/dashboards
- Reports contains reports that have been generated on a dashboard.
- Advanced settings contains UI and other settings  
- Beats management of Filebeat, Logbeat, etc.

### Using Kibana
Use Lucene, not KQL.  
Phrases can be used in searching, but it'll search every field.  
Can use + or -, but is easier and more readable to use AND/OR/AND NOT, etc   
'Exist' keyword is useful, can be used multiple times.  
Wildcard is acceptable in Lucene  
Regex in general is acceptable in Lucene  
