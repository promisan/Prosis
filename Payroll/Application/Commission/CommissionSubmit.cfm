
<!--- record the lines in Miscellaneous : source = Unit : prevent edit ---->

If new trasnaction then create OrganizationAction

Populate PersonEntitlement


Person
CostId : auto
EntityClass = workflowflow class
DateEffective : end of the month
DateExpiration : end of the month
DocumentDate : documentDate
DocumentReference : entry field
PayrollItem : select
EntityMentClass : select
PayrollStart : mail
Currency : driven by the payroll schele selected -> contract enabled schedule.
Quantity / Rate : n/a
Amount : direct entry
Source and Sourceid -> OrganizationAction

Create workflow

If existing then depends on the system, 

if status <= '2' we allow to amend and also add people



