
<cfparam name="Form.CriteriaType" default="">

<cfif Form.CriteriaType eq "">

	<script>
		alert("You have not defined a valid Parameter class")
	</script>
	<cfabort>
	
</cfif>
			
<cfparam name="Form.LookupEnableAll" default="0">	
<cfparam name="Form.ComboBox" default="Select">	
<cfparam name="Form.LookupFieldShow" default="0">	
<cfparam name="Form.criteriadaterelative" default="0">		
<cfparam name="Form.criteriainterface" default="List">	
<cfparam name="Form.criteriavalidation" default="">	
<cfparam name="Form.LookupViewScript" default="">	
<cfparam name="Form.LookupMode" default="Table">	
<cfparam name="Form.LookupUnitParent" default="0">	
<cfparam name="Form.CriteriaDatePeriod" default="0">	

<!--- check cluster --->

<cfset Form.CriteriaName  = Replace(Form.CriteriaName,' ','','ALL')>
<cfset Form.CriteriaName  = Replace(Form.CriteriaName,'.','','ALL')>
<cfset Form.CriteriaName  = Replace(Form.CriteriaName,',','','ALL')>

<cfloop index="par" list="date,parent,window,integer,text,set" delimiters=",">

	<cfif Form.CriteriaName eq "#par#">
	
		<script>
			alert("Your parameter name is not a valid name. Operation not allowed.")
		</script>
		<cfabort>
		
	</cfif>

</cfloop>	

<cfset CriteriaNameParent = Form.CriteriaNameParent>
<cfset criteriaValues     = Form.CriteriaValues>

<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControlCriteria 
	  WHERE   ControlId          = '#Form.ControlId#'
	  AND     CriteriaNameParent = '#Form.CriteriaName#'  
</cfquery>
		
<cfif verify.recordcount gte "1" and Form.ComboBox eq "Combo">

		 <script>
				alert("Problem : Parent criteria may currently not be presented as a web dialog presentation. Please undo the web page dialog checkbox.")
		 </script>
		 <cfabort>	 

</cfif>		

<cfif verify.recordcount gte "1" and Form.CriteriaType eq "Extended">

		 <script>
				alert("Problem : Parent criteria may not be defined as List (Multi field query).")
		 </script>
		 <cfabort>	 

</cfif>		

<cfif Form.CriteriaNameParent neq "" and (Form.CriteriaType eq "Extended" and Form.ComboBox eq "Combo")>

	    <script>
				alert("Problem : Parent definition is not support for type List (Multi field query] with a Web-dialog presentation. Please adjust your criteria configuration.")
		 </script>
		 <cfabort>	 
	 	
</cfif>

<cfif Form.CriteriaNameParent neq "" and (Form.CriteriaType eq "Unit" or Form.CriteriaType eq "Lookup" or Form.CriteriaType eq "Extended")>

	 <cfif not FindnoCase(" IN (@parent)", "#Form.CriteriaValues#") and Form.CriteriaType neq "Unit">
	 
		 <script>
				alert("Problem : Your condition does not have your parent field defined [ IN (@parent)]. Please adjust your condition.")
		 </script>
		 <cfabort>	 
	 
	 </cfif>
	 
<cfelse>

	 <cfset CriteriaNameParent = "">
	 
</cfif>

<cfif Form.CriteriaNameParent eq "" and (Form.CriteriaType eq "Lookup" or Form.CriteriaType eq "Extended")>

	 <cfif Findnocase(" IN (@parent)", "#Form.CriteriaValues#")>
	 
		 <script>
				alert("Problem : Your condition refers to a parent field which has not been defined. Please adjust your condition or select a parent field.")
		 </script>
		 <cfabort>	 
	 
	 </cfif>
		
</cfif>

 
<cfif CriteriaType eq "List">

	<cfset values=Replace(CriteriaValues,' ','','ALL')>
	
<cfelse>

    <cfif Find("SELECT", "#CriteriaValues#") and not Find("(SELECT", "#CriteriaValues#")>
		<script>
			alert("Warning : Your condition has a SELECT statement included. This is only allowed for IN statements.")
		</script>
		<cfabort>
     
    </cfif>
    <cfset values="#CriteriaValues#">
	
</cfif>

 <cfif (Form.CriteriaType eq "TextList" 
       or Form.CriteriaType eq "Text"
       or Form.CriteriaType eq "Lookup" 
	   or Form.CriteriaType eq "Extended") and Form.LookupTable neq "">
	 
	 <cfparam name="Form.LookupTable" default="">    
	 <cfparam name="Form.LookupFieldValue" default="">    
	 <cfparam name="Form.LookupFieldDisplay" default="#Form.LookupFieldValue#">
  	
     <cftry>
		
    	<cfquery name="FieldNames" 
     	 datasource="#form.LookupDatasource#">
     	 SELECT     TOP 1 * 
    	 FROM       #Form.LookupTable#
    	</cfquery>	
			
	   <cfcatch>
	   
		   	<script>
				alert("You have entered an invalid lookup table name.")
			</script>
			<cfabort>
						   	  			
	   </cfcatch>
		
    </cftry> 
		
		
	<cfif findNoCase("#Form.LookupFieldValue#","#FieldNames.columnList#") and 
       	  findNoCase("#Form.LookupFieldDisplay#","#FieldNames.columnList#") and 
		  Form.LookupFieldValue neq "">
		  
		  <!--- go ahead --->
		  
	<cfelse>
	
			<script>
				alert("You have entered an invalid lookup keyfield or display name which does not exisit in the lookup table/view.")
			</script>
			<cfabort>
			
	</cfif>	
	
<cfelse>

    <cfset Form.LookupTable = "">
    <cfset Form.LookupFieldValue = "">
	<cfset Form.LookupFieldSorting = "">
	<cfset Form.LookupFieldDisplay = "">
  	
</cfif>	 

<cfif Form.CriteriaType neq "List">
    <cfset Form.CriteriaInterface = "Standard">
</cfif>
	
<cfif url.option eq "Update" or url.option eq "UpdateClose" or url.option eq "Draft"> 

	<cfif Form.CriteriaNameOld neq Form.CriteriaName>

	    <cfquery name="Verify" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Ref_ReportControlCriteria 
		  WHERE   ControlId    = '#Form.ControlId#'
		  AND     CriteriaName = '#Form.CriteriaName#'  
		</cfquery>
		
		<cfif Verify.recordcount gt "1">
		
			<cfoutput>
		   		 <script>
					alert("A Criteria name: #Form.CriteriaName# already exists. // Action : Change the parameter name.")
				</script>
				<cfabort>
			</cfoutput>		
				
		</cfif>
	
	</cfif> 
	
	<cfif Form.CriteriaCluster neq "">
	
		<cfquery name="Verify" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Ref_ReportControlCriteria 
		  WHERE   ControlId = '#Form.ControlId#'
		  AND     CriteriaName = '#Form.CriteriaCluster#' 
		</cfquery>
		
		<cfif Verify.recordcount gt "1">
			
				<cfoutput>
			   		 <script>
						alert("A Criteria Name: #Form.CriteriaName# already exists with the name of the assigned cluster. // Action : Not allowed")
					</script>
					<cfabort>
				</cfoutput>		
					
		</cfif>
	
	</cfif>
	
	<cfquery name="Verify" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Ref_ReportControlCriteria 
		  WHERE   ControlId = '#Form.ControlId#'
		  AND     CriteriaCluster = '#Form.CriteriaName#' 
	</cfquery>
		
	<cfif Verify.recordcount gt "1">
			
				<cfoutput>
			   		 <script>
						alert("A Cluster with name: #Form.CriteriaName# already exists and conclict with the name of the assigned criteria. // Action : Not allowed")
					</script>
					<cfabort>
				</cfoutput>		
			
	</cfif>
    
	<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControlCriteria 
	  WHERE   ControlId = '#Form.ControlId#'
	  AND   CriteriaName = '#Form.CriteriaNameOld#' 
	</cfquery>
	
	<cfquery name="Verify2" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControlCriteria 
	  WHERE   ControlId     = '#Form.ControlId#'
	  AND     CriteriaName  = '#Form.CriteriaName#' 
	  AND     CriteriaName != '#Form.CriteriaNameOld#'
	</cfquery>
	
	<cfif Form.CriteriaMaskLength lte "0" or Form.CriteriaMaskLength gt "#Len(Form.CriteriaMask)#" >
	      <cfset masklen = Len(Form.CriteriaMask)>
	<cfelse>
		  <cfset masklen = Form.CriteriaMaskLength>
	</cfif>
	
   <cfif Verify.recordCount is 1 and Verify2.recordCount eq "0">
   
	   <cfif Form.LookupEnableAll eq "1" and Form.LookupMultiple eq "1">
	   		<cfset all = 0>
	   <cfelse>
	    	<cfset all = Form.LookupEnableAll>	
	   </cfif>
	   
	   <cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_ReportControlCriteria 
		SET    CriteriaName         = '#lcase(Form.CriteriaName)#', 
	      	   CriteriaNameParent   = '#CriteriaNameParent#',
		       CriteriaDescription  = '#Form.CriteriaDescription#',
			   CriteriaMemo         = '#Form.CriteriaMemo#', 
			   CriteriaError        = '#Form.CriteriaError#',
			   CriteriaHelp         = '#Form.CriteriaHelp#',
		       CriteriaType         = '#Form.CriteriaType#',
			   CriteriaClass        = '#Form.CriteriaClass#',
			   CriteriaMask         = '#Form.CriteriaMask#',
			   CriteriaMaskLength   = '#masklen#',
			   CriteriaValidation   = '#Form.CriteriaValidation#',
			   CriteriaPattern      = '#Form.CriteriaPattern#',
			   CriteriaRole         = '#Form.CriteriaRole#',
			   CriteriaObligatory   = '#Form.CriteriaObligatory#',
			   CriteriaValues       = '#values#',
			   <cfif Form.CriteriaType neq "Date" and Form.CriteriaType neq "Text">
			   CriteriaDefault      = '#Form.CriteriaDefault#',
			   CriteriaDatePeriod   = 0,
			   <cfelse>
			   CriteriaDefault      = '#Form.defaultDate#',
			   CriteriaDatePeriod   = '#Form.CriteriaDatePeriod#',
			   </cfif>
			   <cfif Form.CriteriaType eq "Unit">
			   LookupUnitTree       = '#Form.LookupUnitTree#',
			   LookupFieldValue     = '#Form.LookupUnitTreeKey#', 
			   LookupUnitParent     = '#Form.LookupUnitParent#',
			   <cfelse>
			   LookupFieldValue     = '#Form.LookupFieldValue#',
			   LookupUnitTree       = NULL,
			   LookupUnitParent     = NULL,
			   </cfif>
			   CriteriaCluster      = '#lcase(Form.CriteriaCluster)#',
			   <cfif Form.CriteriaType neq "lookup" and Form.CriteriaType neq "extended" and Form.CriteriaType neq "unit">
			   CriteriaInterface    = '#Form.CriteriaInterface#',
			   <cfelse>
			   CriteriaInterface    = '#Form.ComboBox#',
			   </cfif>
			   LookupEnableAll      = '#all#',
			   LookupMultiple       = '#Form.LookupMultiple#',
			   LookupFieldDisplay   = '#Form.LookupFieldDisplay#',
			   LookupFieldSorting   = '#Form.LookupFieldSorting#',
			   LookupFieldShow      = '#Form.LookupFieldShow#',
			   LookupDataSource     = '#Form.LookupDataSource#',
			   LookupMode           = '#Form.LookupMode#',
			   LookupTable          = '#Form.LookupTable#', 
			   LookupViewScript     = '#Form.LookupViewScript#',  
			   CriteriaDateRelative = '#Form.CriteriaDateRelative#',			   
			   CriteriaWidth        = '#Form.CriteriaWidth#',
			   CriteriaOrder        = '#Form.CriteriaOrder#',
			   Operational          = '#Form.Operational#',
			   RecordStatus         = '1' 
		WHERE  ControlId    = '#Form.ControlId#'
		  AND  CriteriaName = '#Form.CriteriaNameOld#'	    
	   </cfquery>
   
     <cfelseif Verify2.recordCount is 1> 
   
		   <cfoutput>
		    <script>
				alert("You entered a parameter name that is already registered. Operation not allowed.")
			</script>
			<cfabort>
			</cfoutput>
       
   <cfelse>
   
	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ReportControlCriteria 
	         (ControlId, 
			 CriteriaName,
			 CriteriaNameParent,
			 CriteriaDescription,
			 CriteriaMemo, 
			 CriteriaError, 
			 CriteriaHelp,
			 CriteriaType,
			 CriteriaClass,
			 CriteriaValues,
			 CriteriaDefault,
			 CriteriaRole,
			 CriteriaMask,
			 CriteriaMaskLength,
			 CriteriaValidation,
			 CriteriaPattern,
			 LookupMultiple,
			 LookupEnableAll, 
			 CriteriaInterface,
			 CriteriaDateRelative,
			 LookupDataSource,
			 LookupMode,
			 LookupTable,
			 LookupViewScript,
			 LookupFieldValue,
			 LookupFieldDisplay,
			 CriteriaWidth,
			 CriteriaOrder,
			 CriteriaCluster, 
			 CriteriaObligatory,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 RecordStatus,
			 Created)
	  VALUES ('#Form.ControlId#',
	          '#lcase(Form.CriteriaName)#',
			  '#Form.CriteriaNameParent#', 
			  '#Form.CriteriaDescription#',
			  '#Form.CriteriaMemo#',  
			  '#Form.CriteriaError#',
			  '#Form.CriteriaHelp#',
			  '#Form.CriteriaType#',
			  '#Form.CriteriaClass#',
			  '#Form.CriteriaValues#',
			  <cfif Form.CriteriaType neq "Date">
		      '#Form.CriteriaDefault#',
		      <cfelse>
		      '#Form.defaultDate#',
		      </cfif>
			  '#Form.CriteriaRole#',
			  '#Form.CriteriaMask#',
			  '#masklen#',
			  '#Form.CriteriaValidation#',
			  '#Form.CriteriaPattern#',
			  '#Form.LookupMultiple#',
			  '#Form.LookupEnableAll#',
			  <cfif Form.CriteriaType neq "lookup" and Form.CriteriaType neq "extended" and Form.CriteriaType neq "unit">
			  '#Form.CriteriaInterface#', 
			  <cfelse>
			  '#Form.Combobox#', 
			  </cfif>
			  '#Form.CriteriaDateRelative#',
			  '#Form.LookupDataSource#',
              '#Form.LookupMode#',
			  '#Form.LookupTable#',
			  '#Form.LookupViewScript#',
			  '#Form.LookupFieldValue#',
			  '#Form.LookupFieldDisplay#',
			  '#Form.CriteriaWidth#',
			  '#Form.CriteriaOrder#',
			  '#lcase(Form.CriteriaCluster)#',
			  '#Form.CriteriaObligatory#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  <cfif url.option eq "Draft">
			  '0',
			  <cfelse>
			  '1',
			  </cfif>
			  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>


<!--- disabled

<cfquery name="Cluster" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ReportControlCriteria 
SET CriteriaOrder = '#Form.CriteriaOrder#'
WHERE   ControlId = '#Form.ControlId#'
  AND   CriteriaCluster = '#Form.CriteriaCluster#'
  AND   CriteriaCluster is not NULL
  AND   CriteriaCluster != ''
</cfquery>

--->

<cfif url.option eq "Delete"> 

	<cfquery name="CountRec" 
      datasource="AppsSystem" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE 
      FROM Ref_ReportControlCriteria 
      WHERE  ControlId = '#Form.ControlId#'
	  AND  CriteriaName = '#Form.CriteriaNameOld#'	   
    </cfquery>
    	
</cfif>

<cfif url.option eq "ClearMe"> 

	<cfquery name="CountRec" 
      datasource="AppsSystem" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE 
      FROM Ref_ReportControlCriteria 
      WHERE  ControlId = '#Form.ControlId#'
	  AND  CriteriaName = '#Form.CriteriaNameOld#'	   
    </cfquery>

</cfif>

<cf_uiupdate controlid = "#Form.ControlId#">

<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControlCriteria 
	  WHERE   ControlId = '#Form.ControlId#'
	  AND   (CriteriaName = '#Form.CriteriaName#' and CriteriaCluster = '#Form.CriteriaName#')  
</cfquery>

<cfif Verify.recordcount gte "1">
	
		<cfoutput>
	   		 <script>
				alert("A Criteria Name with a name of a cluster Name: #Form.CriteriaCluster# exists. // Action : Change the cluster name.")
			</script>
			<cfabort>
		</cfoutput>		
			
</cfif>

<cfif Form.CriteriaType eq "Extended">

<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControlCriteriaField
	  WHERE   ControlId = '#Form.ControlId#'
	  AND     CriteriaName = '#Form.CriteriaName#'  
</cfquery>

<cfif Verify.recordcount eq "1">
	
		<cfoutput>
	   		 <script>
				alert("An extended criteria will need to have at least two fields defined.")
			</script>
			<cfabort>
		</cfoutput>		
			
</cfif>

</cfif>

<!--- check --->

<cfquery name="UserReport" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControl
	  WHERE   ControlId = '#Form.ControlId#'
	</cfquery>
	
   <cftry>
      
	<cfif UserReport.ReportRoot eq "Application" or UserReport.ReportRoot eq "">
	   <cfset rootpath  = "#SESSION.rootpath#">
	<cfelse>
	   <cfset rootpath  = "#SESSION.rootReportPath#">
	</cfif>

   <cffile action = "read"
	 	  file = "#rootpath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#"
		  variable = "sql">  
		  
	<cfif Find("Form.#Form.CriteriaName#", "#sql#")>	  
		<cfset warning = "0">
	<cfelse>
	    <cfset warning = "0">  <!--- was : 1 --->
	</cfif>
	
	<cfcatch> 
	   <cfset warning = "0">
	</cfcatch>
	
	</cftry>
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
	
			
	<script language="JavaScript">
		
		<cfoutput>
				     
		     <cfif warning eq "1">
	    	     alert("Parameter saved. // Alert : The parameter name FORM.#Form.CriteriaName# is not declared in the stored procedure (#UserReport.TemplateSQL#)")
			 </cfif>
						 			 
			 <cfif url.option eq "UpdateClose" or url.option eq "Delete">
			     opener.history.go()
				 window.close()
				<!--- opener.location = "Criteria.cfm?id=#Form.ControlID#&status=#url.status#" --->
			 <cfelseif  url.option eq "ClearMe">
			     ptoken.location('CriteriaEdit.cfm?id1=&id=#Form.ControlID#&status=#url.status#&mid=#mid#')			  
			 <cfelse>			    
			     ptoken.location('CriteriaEdit.cfm?id1=#form.criterianame#&id=#Form.ControlID#&status=#url.status#&mid=#mid#')			  
			 </cfif>
						 
		</cfoutput>	 
	</script>  
	
