
<cfparam name="url.Operational"     default="0">
<cfparam name="url.TopicValue"      default="">
<cfparam name="url.ListOrder"       default="">
<cfparam name="url.ListDefault"     default="0">
<cfparam name="url.id2"             default="new">

<cfif url.listdefault eq "true">
  <cfset listdefault = 1>
<cfelse>
  <cfset listdefault = 0> 
</cfif>

<cfif url.operational eq "true">
  <cfset operational = 1>
<cfelse>
  <cfset operational = 0> 
</cfif>

<cfif isNumeric(url.ListOrder)>

<cfelse>

	<cfoutput>
		<script>
		alert("Sorry, but order value: #url.ListOrder# is incorrect")		
		 ptoken.navigate('Budgeting/List.cfm?Code=#URL.Code#&ID2=#url.id2#','list')	
		</script>
	</cfoutput>
	<cfabort>
		
</cfif>		

<cfset listamount = replace(url.listamount,",","")>

<cfif isNumeric(ListAmount)>

<cfelse>

	<cfoutput>
		<script>
		alert("Sorry, but numeric value #url.ListAmount# is incorrect")		
		 ptoken.navigate('Budgeting/List.cfm?Code=#URL.Code#&ID2=#url.id2#','list')	
		</script>
	</cfoutput>
	<cfabort>
		
</cfif>		
		
<cfset topicvalue     = url.topicvalue>
<cfset listorder      = url.listorder>


<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE ItemMasterList
		  SET    Operational         = '#Operational#',
 		         TopicValue          = '#TopicValue#',
				 ListOrder           = '#ListOrder#',
				 ListDefault         = '#ListDefault#',
				 ListAmount          = '#ListAmount#'
		  WHERE  TopicValueCode      = '#URL.ID2#'
		   AND   ItemMaster          = '#URL.Code#' 
	</cfquery>
	
	<cfif ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE ItemMasterList
			  SET    ListDefault = 0
			  WHERE  TopicValueCode <> '#URL.ID2#'
			   AND   ItemMaster = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	<cfset url.id2 = "">
				
<cfelse>

	<cfif url.topicvaluecode eq "">
	
		<cfoutput>
	    <script>
		alert("Sorry, invalid code")		
		 ptoken.navigate('Budgeting/List.cfm?Code=#URL.Code#&ID2=#url.id2#','list')	
		</script>
		<cfabort>
		</cfoutput>
	
	</cfif>
			
	<cfquery name="Exist" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM ItemMasterList
		  WHERE  TopicValueCode = '#TopicValueCode#'
		   AND   ItemMaster = '#URL.Code#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ItemMasterList
				         (ItemMaster,
						 TopicValueCode,
						 TopicValue,
						 ListAmount,
						 ListOrder,
						 ListDefault,
						 Operational)
			      VALUES ('#URL.Code#',
				      '#TopicValueCode#',
					  '#TopicValue#',
					  '#ListAmount#',
					  '#ListOrder#',
					  '#ListDefault#',
			      	  '#Operational#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #TopicValueCode# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
		
	<cfif ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE ItemMasterList
			  SET    ListDefault = 0
			  WHERE  TopicValueCode <> '#TopicValueCode#' 
			   AND   ItemMaster = '#URL.Code#' 
		</cfquery>
	
	</cfif>
		   	
</cfif>


<cfoutput>
  <script>
    _cf_loadingtexthtml=''
    ptoken.navigate('Budgeting/List.cfm?Code=#URL.Code#&ID2=','list')	
  </script>	
</cfoutput>

