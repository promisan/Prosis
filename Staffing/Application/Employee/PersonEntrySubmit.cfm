<cfparam name="url.mode" default="">

<cfif Len(Form.LastName) lt 2>
	 <cf_alert message = "You have not entered a valid Last name">
	 <cfabort>
</cfif>

<cfif Len(Form.Remarks) gt 200>
	 <cf_alert message = "You entered remarks that exceeded the allowed size of 200 characters.">
	 <cfabort>
</cfif>

<cfparam name="Form.PersonStatus"     default="">
<cfparam name="Form.BirthNationality" default="">
<cfparam name="Form.Gender"           default="Male">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DOB#"  SQLLimit="Yes">
<cfset DOB = dateValue>

<cfset dateValue = "">
<cfif Form.OrganizationStart neq "">
    <CF_DateConvert Value="#Form.OrganizationStart#"  SQLLimit="Yes">
    <cfset STR = dateValue>
<cfelse>
    <CF_DateConvert Value="01/01/80">
    <cfset STR = dateValue>
</cfif>	

<!--- verify is person record exist --->

<cfquery name="PersonExists" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Person
	WHERE   (IndexNo = '#Form.IndexNo#' AND IndexNo is not NULL AND IndexNo != '')
			
</cfquery>

<cfif PersonExists.recordCount gt 0>  
	<cfoutput>
		<cf_alert message = "Another employee with the #client.IndexNoName# #Form.IndexNo# is already registered. Operation aborted">
	</cfoutput>
	 <cfabort>
</cfif>

<!--- verify is person record exist --->

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Person
	WHERE   LastName   = '#Form.LastName#' 
	AND     FirstName  = '#Form.FirstName#'        
	AND  	IndexNo NOT LIKE '%#Form.IndexNo#%'
			
</cfquery>

<cfparam name="Person.RecordCount" default="0">
<cfparam name="url.force" default="0">

<cfif Person.recordCount gt 0 AND ParameterExists(Form.Submit) and url.force eq "0">  

	<table><tr><td><font height="20" face="Verdana">The following existing employees records match your entry.</b></td></tr></table>

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<TR class="labelmedium line">
	    <TD></TD>
	    <TD><cfoutput>#client.IndexNoName#</cfoutput></TD>
	    <TD><cf_tl id="LastName"></TD>
	    <TD><cf_tl id="FirstName"></TD>
	    <TD>Nat.</TD>
	    <TD><cf_tl id="Gender"></TD>
	    <TD><cf_tl id="Birth date"></TD>
	    <TD><cf_tl id="Birth city"></TD>
	    <TD><cf_tl id="Parent Office"></TD>
	    <TD><cf_tl id="Source"></TD>
	
	</TR>
		
	<cfoutput query="Person">
	   
	   <TR class="labelmedium line">
		   <TD>
		      <cf_img icon="open" onclick="javascript:EditPerson('#PersonNo#')">
		   </td>	
		   <TD>#IndexNo#</TD>
		   <TD>#LastName#</TD>
		   <TD>#FirstName#</TD>
		   <TD>#Nationality#</TD>
		   <TD>#Gender#</TD>
		   <TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
		   <TD>#BirthCity#</TD>
		   <TD>#ParentOffice# #ParentOfficeLocation#</TD>
		   <TD>#Source#</TD>
	   </TR>
	      			 
	</CFOUTPUT>
	
	<tr><td colspan="10" align="center">
		
			<input type="submit"
			    name="Save" 
				value="Submit Employee anyway" 
				class="button10g" 
				style="width:200px"
				onclick="ptoken.navigate('PersonEntrySubmit.cfm?force=1&personno=#url.personNo#&mode=#url.mode#','result','','','POST','formperson')">

	</td></tr>
	
	</table>

<CFELSE>

   <cfquery name="AssignNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
    	 UPDATE Parameter 
		 SET    PersonNo = PersonNo+1
     </cfquery>
	 
	  <cfquery name="LastNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
    	 SELECT *
	     FROM   Parameter
	 </cfquery>
	 
	 <cfif LastNo.IndexNo neq "0">
		
		 <cfquery name="AssignNo" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 UPDATE Parameter 
			 SET    Indexno = IndexNo+1
	     </cfquery>			
		
	</cfif>

     <cfquery name="LastNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
    	 SELECT *
	     FROM   Parameter
	 </cfquery>
	 
	 <cfif LastNo.IndexNo neq "0">	 
	 	<cfset index = LastNo.IndexNo>		
	 <cfelse>	 
	 	<cfset index = replace(Form.IndexNo," ","","ALL")>	 
	 </cfif>
	 
	 <cfquery name="PersonStatus" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PersonStatus
			WHERE  Code = '#Form.PersonStatus#'	
	</cfquery>
	
	<cfset pre = "">
	<cfif PersonStatus.recordcount eq "1">
		<cfset pre = PersonStatus.Code>
	</cfif>
 
    <cfquery name="InsertPerson" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO Person 
		        (PersonNo,
				 IndexNo, 
				 LastName,
				 MaidenName,
				 FirstName,
				 MiddleName,
				 BirthDate,
				 Gender,
				 Bloodtype,
				 Nationality,
				 MaritalStatus,
				 BirthNationality,
				 BirthCity,
				 RecruitmentCountry,
				 RecruitmentCity,
				 OrganizationStart,
				 <cfif Form.PersonStatus neq "">
				 PersonStatus,
				 </cfif>
				 Reference,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Remarks,	
				 Source)
	      VALUES ('#LastNo.PersonNo#',
		          '#pre##Index#',
				  '#Form.LastName#',
				  '#Form.MaidenName#',
				  '#Form.FirstName#',
				  '#Form.MiddleName#',
				  #DOB#,
				  '#Form.Gender#',
				  '#Form.Bloodtype#',
				  '#Form.Nationality#',
				  '#Form.MaritalStatus#',
				  '#Form.BirthNationality#',
				  '#Form.BirthCity#',
				  '#Form.RecruitmentCountry#',
				  '#Form.RecruitmentCity#',
			      #STR#,
				  <cfif Form.PersonStatus neq "">
				  '#Form.PersonStatus#',
				  </cfif>
				  '#Form.Reference#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#Form.Remarks#',
				  'MANUAL')
        </cfquery>
		
		<!--- and generate a workflow --->
		
		<cfif url.mode eq "recruitment">
		 
			 <!--- no action / workflow generated --->
			 
		<cfelse>	 
		 
		 	<!--- ------------------------------------- --->
			<!--- track action of the add person record --->
			<!--- ------------------------------------- --->
			
			<cfquery name="getMission" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM   Ref_ParameterMission
			</cfquery>  
			
			<cfif getMission.recordcount gte "2">
			
				<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#LastNo.PersonNo#"
				   ActionCode1        = "1000"
				   Field1             = "Record"
				   ActionStatus       = "1">	
				   
			<cfelse>
			
				<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#LastNo.PersonNo#"
				   Mission            = "#getMission.Mission#"
				   ActionCode1        = "1000"
				   Field1             = "Record"
				   ActionStatus       = "1">	
					
			</cfif>   
			
			<!--- generate workflow --->
			
			<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
			     method           = "ActionWorkFlow" 
			     PersonNo         = "#LastNo.PersonNo#">					   		
					 
		</cfif>		 
		   		
		  
		<!--- also save the custom fields --->
		  
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Parameter
		</cfquery>  
		
		<!---		
		<cfif Parameter.EnablePersonGroup eq "1">
		--->
		  
			<cfquery name="Topic" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			  FROM  Ref_PersonGroup
			  WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)
			</cfquery>
			  
			 <cfloop query="topic">
			 
			 	 <cfparam name="Form.ListCode_#Code#" default="">
						        
			     <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
				 
				 <cfif listcode neq "">
							  
				   <cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO PersonGroup
						 (PersonNo,
						  GroupCode,
						  GroupListCode, 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
					 VALUES
					 ('#LastNo.PersonNo#', '#Code#', '#ListCode#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
					</cfquery>
					
				  </cfif>	
				   
			  </cfloop>	 
		 
		 <!--- 
		 </cfif>  
		 --->
		 		 
		 <cfset pers = LastNo.PersonNo>		 
		 
		 <!--- also generate a related candidate record for this person --->
		 <cfif Parameter.GenerateApplicant eq "1">
		 				 
			 <cfset mode = "Copy">
			 <cfparam name="Form.EmployeeNo"     default="#LastNo.PersonNo#">
			 <cfparam name="Form.ApplicantClass" default="1">
			 <cfparam name="Form.LastName2" 	 default="">
			 <cfinclude template="../../../Roster/Candidate/Details/Applicant/ApplicantEntrySubmit.cfm">
					 		 
		 </cfif>

     <cfoutput>
	 
	 <cfif url.mode eq "recruitment">
	 
	 	 <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 UPDATE Applicant
			 SET    EmployeeNo = '#pers#', 
			        IndexNo    = '#IndexNo#'
			 WHERE  PersonNo   = '#URL.PersonNo#'						 
	     </cfquery> 	
	 
		<script>		
		    parent.parent.document.getElementById('indexno').value = '#IndexNo#'	
			parent.parent.ProsisUI.closeWindow('myperson')							
		</script> 	
		
	 <cfelseif url.mode eq "lookup">	
	 		 
		 <cfset link    = replace(url.link,"||","&","ALL")>
					 
	     <script>		
		   
		    if (document.getElementById('#url.box#')) {
			  ptoken.navigate('#link#&action=insert&personno=#pers#','#url.box#')
			} else {
			  ptoken.navigate('#link#&action=insert&personno=#pers#','searchresult#url.box#')
			}
		 	ColdFusion.Window.hide('dialog#url.box#')			     
	   
		</script>	
	 	 
	 <cfelse>
	 
		 <cf_systemscript>
		 
	     <script>
		   
		    ptoken.location('PersonEntry.cfm')	 	 
	        w = 0
	        h = 0
	        if (screen) {
		        w = #CLIENT.width# - 20;
	    	    h = #CLIENT.height# - 90;
				ptoken.open("#SESSION.root#/Staffing/Application/Employee/PersonView.cfm?ID=#pers#", "Employee", "left=10, top=10, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
			
	       }
	   
		</script>	
	
	</cfif>
	
	</cfoutput>	   
	
</cfif>	

