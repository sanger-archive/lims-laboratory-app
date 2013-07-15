This folder contains a script to fix the incorrect label values in the production DBs 
(S2 and Sequencescape DBs) and the warehouse.
It iterates over the given file's entries and copies the incorrect label values
to another position - so that we have them to hand in the future if needed -
and update the existing ones with the correct labels.
It uses the following actions from lims-laboratory-app:
    - CreateLabel: to move the existing label to a new position
    - UpdateLabel: to update the invalid label's value
This whole operation should be in a transaction, so I used
Lims::Core::Actions::Action to implement it.

To run the script you have to execute the following file:

start_barcode_fixing.rb

with the following parameters:

-f <the path of the mapping file to create> for example: ~/barcode_mapping.txt
-u <the URL of the running S2 application> for example: "http://localhost:9292/"

Here is a full example:

bundle exec ruby script/fix_barcodes/start_barcode_fixing.rb 
    -f /Users/a1/lims-support-app/barcode_mapping.txt
    -u http://localhost:9292/
