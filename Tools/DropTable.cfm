
<cfparam name="attributes.Full"     default="0">
<cfparam name="attributes.Range"    default="">
<cfparam name="SESSION.login"       default=""> 
<cfparam name="SESSION.dbpw"        default=""> 
<cfparam name="attributes.timeout"  default="30"> 

<cfif attributes.range eq "">
	
	<cfif SESSION.login neq "" and attributes.full eq "0">
	  
	     <cftry>
	   
		  <cfquery name="DELETEME"
	         datasource="#Attributes.dbname#"
	         timeout="#attributes.timeout#"
	         username="#SESSION.login#"
	         password="#SESSION.dbpw#">
				if exists  (SELECT * 
						    FROM   dbo.sysobjects 
			                WHERE  id = object_id(N'[#Attributes.tblname#]') 
			                AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)
				   
			   DROP   table [#Attributes.tblname#]
				   
			   SELECT TOP 1 *  FROM Sysfiles
			</cfquery>
			
		    <cfcatch></cfcatch>
		  
		  </cftry>	  
	  
	<cfelse>
	  
	      <cftry>
		 
			  <cfquery name="DELETEME"
			   timeout="#attributes.timeout#"
			   datasource="#Attributes.dbname#">
			   if exists 
				  (SELECT * 
				   FROM   dbo.sysobjects 
				   WHERE  id = object_id(N'[#Attributes.tblname#]') 
				   AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)				   
				   DROP   table [#Attributes.tblname#]				   
				   SELECT TOP 1 *  FROM Sysfiles
			  </cfquery>
		  
		     <cfcatch></cfcatch>
		  
		  </cftry>
	  
	</cfif>
	
<cfelse>

	<cfloop index="fileno" from="0" to="#attributes.range#">
		
		<cfif SESSION.login neq "" and attributes.full eq "0">
	  
	     <cftry>
	   
		  <cfquery name="DELETEME"
	         datasource="#Attributes.dbname#"
	         timeout="#attributes.timeout#"
	         username="#SESSION.login#"
	         password="#SESSION.dbpw#">
				if exists  (SELECT * 
						    FROM   dbo.sysobjects 
			                WHERE  id = object_id(N'[#Attributes.tblname#_#fileno#]') 
			                AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)
				   
			   DROP   table [#Attributes.tblname#_#fileno#]
				   
			   SELECT TOP 1 *  FROM Sysfiles
			</cfquery>
			
		    <cfcatch></cfcatch>
		  
		  </cftry>	  
	  
		<cfelse>
	  
	      <cftry>
		 
			  <cfquery name="DELETEME"
			   timeout="#attributes.timeout#"
			   datasource="#Attributes.dbname#">
			   if exists 
				  (SELECT * 
				   FROM   dbo.sysobjects 
				   WHERE  id = object_id(N'[#Attributes.tblname#_#fileno#]') 
				   AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)				   
				   DROP   table [#Attributes.tblname#_#fileno#]				   
				   SELECT TOP 1 *  FROM Sysfiles
			  </cfquery>
		  
		     <cfcatch></cfcatch>
		  
		  </cftry>
	  
		</cfif>
	
	</cfloop>
	

</cfif>	
  