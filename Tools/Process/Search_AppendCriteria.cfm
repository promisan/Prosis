
<CFSET Flds  = Attributes.fieldName>

<CFSET Value = Attributes.value>
<CFIF Attributes.FieldType is not 'DATETIME'>
	<!--- escape quotes if field type is not datetime --->
	<CFSET Value = Replace( Value, "'", "''", "ALL" )>
		
<CFELSE>
	
	<cfif APPLICATION.DateFormat is 'EU'>
	
	   <cfif mid(Value,2,1) eq "/">
	            <cfset d      = '0'&left(Value,1)>
	               <cfif mid(#Value#,4,1) eq "/">
	                    <cfset m      = '0'&mid(Value,3,1)>
	               <cfelse>
	                    <cfset m      = mid(Value,3,2)>
	              </cfif>
	
	   <cfelse>
	
	            <cfset d      = left(Value,2)>
	               <cfif mid(Value,5,1) eq "/">
	                    <cfset m      = '0'&mid(Value,4,1)>
	               <cfelse>
	                    <cfset m      = mid(Value,4,2)>
	              </cfif>
	   </cfif>
	         
	   <cfset y      = mid(Value,len(Value)-1,2)>
	   <cfset st = FindOneOf("./-", y, 1)>
	   <cfif st eq 1>
	      <cfset y      = '0'&mid(Value,len(Value),1)>
	   </cfif>
	   
	   <cfif y gte 10>
	      <cfset y = "19"&#y#> 
	   <cfelse>
	   	  <cfset y = "20"&#y#> 
	   </cfif>
	   
	   <cfset value   = "{d '"&#y#&"-"&#m#&"-"&#d#&"'} ">
	
	</cfif>

</CFIF>

<cfset criteria = "">

<cfloop index="val" list="#value#" delimiters="\/">

	<cfif val neq "">
	
		<cfset crit = "">
		
		<cfloop index="fld" list="#flds#">
				
			<CFIF ListFindNoCase( 'CHAR,MEMO', Attributes.FieldType )>
				<CFIF Attributes.operator is 'EQUAL'>       <CFSET Crit = fld & " = '#val#' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'NOT_EQUAL'>   <CFSET Crit = fld & " <> '#val#' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'GREATER_THAN'><CFSET Crit = fld & " > '#val#' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'SMALLER_THAN'><CFSET Crit = fld & " < '#val#' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'CONTAINS'>    <CFSET Crit = fld & " LIKE '%#Replace(val," ","%","ALL")#%' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'BEGINS_WITH'> <CFSET Crit = fld & " LIKE '#val#%' #CLIENT.Collation# ">
				<CFELSEIF Attributes.operator is 'ENDS_WITH'>   <CFSET Crit = fld & " LIKE '%#val#' #CLIENT.Collation# ">
				</CFIF>		
			<CFELSEIF ListFindNoCase( 'INT,FLOAT,BIT,DATETIME', Attributes.FieldType )>
				<CFIF Attributes.operator is 'EQUAL'>           <CFSET Crit = fld & " = #val# ">
				<CFELSEIF Attributes.operator is 'NOT_EQUAL'>   <CFSET Crit = fld & " <> #val# ">
				<CFELSEIF Attributes.operator is 'GREATER_THAN'><CFSET Crit = fld & " > #val# ">
				<CFELSEIF Attributes.operator is 'SMALLER_THAN'><CFSET Crit = fld & " < #val# ">
				</CFIF>
			</CFIF>
					
			<cfif criteria eq "">
				<cfset Criteria = "#crit#">
			<cfelse>
			    <cfset Criteria = Criteria & " OR #crit#">
			</cfif>
								
		</cfloop>
		
		<cfset Criteria = "(#Criteria#)">
		
					
	</cfif>	

</cfloop>

<cfif criteria neq "">
	
	<CFIF Trim( Caller.Criteria ) is ''>
		  <CFSET Caller.Criteria = Caller.Criteria & Criteria>
	<CFELSE>
	  <CFSET Caller.Criteria = Caller.Criteria & " AND " & Criteria>
	</CFIF>

</cfif>


