<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_PostGrade
	WHERE 
	PostGrade  = '#Form.PostGrade#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A postgrade with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   	<cftry>
   
   	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_PostGradeBudget
	         (PostGradeBudget,
			 PostOrderBudget,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.PostGradeBudget#',
			  '#Form.PostOrder#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>
   
	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_PostGrade
	         (PostGrade,
			 PostOrder,
			 PostGradeBudget,
			 PostOrderBudget,
			 PostGradeParent,
			 PostGradeDisplay,
			 PostGradeSteps,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.PostGrade#',
			  '#Form.PostOrder#',
			  '#Form.PostGradeBudget#',
			  '#Form.PostOrder#',
			  '#Form.PostGradeParent#',
	          '#Form.PostGradeDisplay#', 
			  '#Form.PostGradeSteps#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
   	<cftry>
   
   	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_PostGradeBudget
		         (PostGradeBudget,
				 PostOrderBudget,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.PostGradeBudget#',
				  '#Form.PostOrder#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	</cftry>
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Postgrade
	SET 
	   PostGrade   		     = '#Form.PostGrade#',
	   PostOrder  		     = '#Form.PostOrder#',
	   PostGradeBudget       = '#Form.PostGradeBudget#',
	   PostOrderBudget       = '#Form.PostOrder#',
	   PostGradePosition     = '#Form.PostGradePosition#',
	   PostGradeContract     = '#Form.PostGradeContract#',
	   PostGradeVactrack     = '#Form.PostGradeVactrack#',
	   PostGradeSteps        = '#Form.PostGradeSteps#',
	   PostGradeStepInterval = '#Form.PostGradeStepInterval#', 
	   PostGradeParent       = '#Form.PostGradeParent#',
	   PostGradeDisplay      = '#Form.PostGradeDisplay#'
	WHERE PostGrade = '#Form.PostGradeOld#'
	</cfquery>

	<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *,replace(PostGrade,'-','_')PostGrade1
	    FROM   Ref_PostGrade
	    WHERE  PostGrade = '#Form.PostGrade#'
	</cfquery>

	<!-----must insert into Ref_postGradeStep ---->
	<cfset thisIndex = 1>
	
	<cfloop condition = "thisindex lte Get.PostGradeSteps">
		<cfset saveStep = "00">
		<cfif thisIndex lte 9>
			<cfset saveStep = "0#thisIndex#">
		<cfelse>
			<cfset saveStep = "#thisIndex#">
		</cfif>
		<cfset stepInterval = evaluate("Form.PostOrder_#Get.postGrade1#_#saveStep#")> 
		<cfset stepAction = evaluate("Form.PostOrder_#Get.postGrade1#_#saveStep#_action")> 
		<!----cast it to Interger ---->
		<cfset stepInterval = stepInterval + 0>

		<cfif stepAction eq "insert">

			<cfquery name="Insert" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_PostGradeStep
	         				(PostGrade,
			 				DateEffective,
			 				Step,
			 				StepInterval,
			 				OfficerUserId,
			 				OfficerLastName,
			 				OfficerFirstName)
	  			VALUES ('#Get.PostGrade#',
			  			'#DAteFormat(now(),Client.datesql)#',
			  			'#saveStep#',
			  			'#stepInterval#',
			  			'#SESSION.acc#',
	    	  			'#SESSION.last#',		  
		  	  			'#SESSION.first#')
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Upd" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_PostGradeStep
				SET    StepInterval  = '#stepInterval#'
				WHERE  PostGrade     = '#Get.PostGrade#'
				AND    Step 	     = '#saveStep#'
			</cfquery>

		</cfif>

	<cfset thisIndex = thisIndex + 1>

	</cfloop>
	
	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PostGrade
      FROM  Position
      WHERE PostGrade  = '#Form.PostGradeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Post grade is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_PostGrade
	WHERE PostGrade = '#FORM.PostGradeOld#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
