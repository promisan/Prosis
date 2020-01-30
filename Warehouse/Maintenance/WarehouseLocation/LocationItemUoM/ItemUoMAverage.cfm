
<cftry>

<cfquery name="Average" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    SUM(I.TransactionQuantityBase) as Total						   
		 FROM      ItemTransaction I
		 WHERE     I.Warehouse        = '#url.warehouse#'
		 AND       I.Location         = '#url.location#'		
		 AND       I.ItemNo           = '#url.itemno#'
		 AND       TransactionUoM     = '#url.UoM#'	
		 AND       I.TransactionType  = '2'		 				
		 AND       TransactionDate > getDate() - #url.period#	
</cfquery>
	
<cfset avg = -1*average.total/url.period>
				
<cfoutput><b>#numberformat(avg,"__,__._")#  
	
	<input type="hidden" 
	       class="regular" 
		   name="distributionaverage" 
		   id="distributionaverage" 
		   size="10"
		   readonly
		   value="#numberformat(avg,'__,__')#" 
		   style="text-align:right">	
		   
 	

<script>

  d = document.getElementById("distributiondays").value     
  ColdFusion.navigate('ItemUoMMinimum.cfm?days='+d+'&quantity=#avg#','minimum')

</script>

</cfoutput>	  

<cfcatch>

n/a

</cfcatch>	   	

</cftry>

