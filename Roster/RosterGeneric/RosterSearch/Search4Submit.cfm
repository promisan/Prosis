<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Search" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   RosterSearch
	WHERE  SearchId = '#URL.ID#'
</cfquery>  	   

<cfquery name="Clear" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        DELETE FROM  RosterSearchLine
        WHERE  SearchId    = '#URL.ID#' 
	    AND    SearchStage = '4'
 </cfquery>

<!--- insert criteria class --->

<cfparam name="Form.ApplicantClass" type="any" default="All">

	   <cftry>

	  	   <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	       	  (SearchId, SearchClass, SelectId, SearchStage)
	          VALUES 
			  ('#URL.ID#','CandidateClass','#Form.ApplicantClass#','4') 
	       </cfquery>
	   
	   <cfcatch>
	   
		   <cf_preventCache>
		   <cf_message message="We're sorry but your search could not be completed as planned. Please close this window and perform your search again.">
		   <cfabort>
	   
	   </cfcatch>
	   
	   </cftry>
	   
	   <!--- update from database --->
		
		<cfquery name="Update" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RosterSearchLine
		 SET    SelectDescription = S.Description
		 FROM   RosterSearchLine RL INNER JOIN Ref_ApplicantClass S ON RL.SelectId =  S.ApplicantClassId 
		 WHERE  RL.SearchId    = '#URL.ID#'
		 AND    RL.SearchClass = 'CandidateClass'
	    </cfquery>	
	
<!--- ---------------------- --->			
<!--- insert criteria status --->

<cfparam name="Form.date_effective" default="">
<cfparam name="Form.date_expiration" default="">

<cfset cnt = 0>

<cfquery name="qStatus" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_StatusCode
	WHERE    Owner  = '#search.owner#'
	AND      Id     = 'FUN'
</cfquery>					

<cfloop query = "qStatus">
			  	
	    <cftry>
		    <cfset  vStatus = Evaluate("FORM.chk_#qStatus.Status#")>
		<cfcatch>
		    <cfset vStatus = 0>
		</cfcatch>	  
		</cftry>	  
		  
	   <cfif vStatus neq 0>
				 		
				  <cfif EnableStatusDate eq "1">
				  				   
					<cfset vDate  = Evaluate("FORM.eff_#qStatus.Status#")>
					<cfif vDate neq ''>
					    <CF_DateConvert Value="#vDate#">
					    <cfset EFF = dateValue>
					<cfelse>
					    <cfset EFF = 'NULL'>
					</cfif>	
					
					<cfset vDate  = Evaluate("FORM.exp_#qStatus.Status#")>
					<cfif vDate neq ''>
					    <CF_DateConvert Value="#vDate#">
					    <cfset EXP = dateValue>
					<cfelse>
					    <cfset EXP = 'NULL'>
					</cfif>	
					
				  <cfelse>
				  
				  	  <cfset EFF = 'NULL'>
					  <cfset EXP = 'NULL'>				  	  
						
				  </cfif>
				 
				  <cfquery name="Insert" 
				     datasource="AppsSelection" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				        INSERT INTO RosterSearchLine
				         (SearchId,
					      SearchClass,
						  SelectId,
						  SelectDescription,
						  SelectDateEffective,
						  SelectDateExpiration,						  	  
						  SearchStage)
				        VALUES ('#URL.ID#',
					       'Assessment', 
				          '#qStatus.Status#','#qStatus.Meaning#',
						  #EFF#,
						  #EXP#,						   
						  '4')
			    </cfquery>
		</cfif>		
</cfloop>	

	
<cfloop index="itm" list="eff_Application,exp_Application" delimiters=",">	
		
	<cfparam name="Form.#itm#" type="any" default="">	
	
	<cfif evaluate("form.#itm#") neq "">	
	
		<cfswitch expression="#itm#">			
			<cfcase value="eff_Application"> <cfset vItm  = "ApplicationFrom"> </cfcase>
			<cfcase value="exp_Application"> <cfset vItm  = "ApplicationUntil"> </cfcase>				
		</cfswitch>
		
		<cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,
		      SearchClass,
			  SelectId,
			  SelectDescription,
			  SearchStage)
	        VALUES ('#URL.ID#',
			       '#vItm#', 
		          '#evaluate("form.#itm#")#',
				  '#evaluate("form.#itm#")#',
			      '4')
	    </cfquery>	
		
	</cfif>	

</cfloop>

<!--- ---------------------- --->			
<!--- insert criteria status --->

<cfparam name="Form.ReferenceNo" type="any" default="">

	<cfif Form.ReferenceNo neq "">
	
	  <cfquery name="VA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * FROM FunctionOrganization
		WHERE FunctionId = '#Form.ReferenceNo#'		
      </cfquery>
	
      <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		
        INSERT INTO RosterSearchLine
         (SearchId,
		  SearchClass,
		  SelectId,
		  SelectDescription,
		  SearchStage)
        VALUES 
		  ('#URL.ID#',
	       'VA', 
           '#Form.ReferenceNo#',
		   '#VA.ReferenceNo#',
		   '4')
		   
      </cfquery>
	
	</cfif>
	
<!--- ---------------------- --->			
<!--- insert candidate review --->

<cfparam name="Form.ReviewClass" type="any" default="">

	<cfquery name="Check" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT SelectId, Code, Description
		FROM   RosterSearchLine RIGHT OUTER JOIN Ref_ReviewClass R ON R.Code = SelectId
		  AND  SearchId = '#URL.ID#'
   		  AND  SearchClass = 'ReviewClass'
		 WHERE R.Operational = 1		 
	</cfquery>
	
	<cfloop query="check">
	
	<cfparam name="Form.Rev_#Code#" type="any" default="">
	<cfset cd = "#evaluate("Form.Rev_#Code#")#">
	
	<cfif cd neq "">
	
	 <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,
		 SelectParameter,
		 SearchStage)
		 VALUES
		 ('#URL.ID#', 'ReviewClass', '#Code#', '#Description#', '#cd#', '4')
	  </cfquery>	 
			
	</cfif>
	
	</cfloop>

    <cfif Form.ReviewClass neq "">

      <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
	        INSERT  INTO RosterSearchLine
	                (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
			SELECT  '#URL.ID#', 
			        'ReviewClass', 
					Code, 
					Description, 
					'4'
			FROM    Ref_ReviewClass
			WHERE   Code IN (#preserveSingleQuotes(Form.ReviewClass)#)        
	    </cfquery>
		
	</cfif>
	
<!--- ---------------------- --->			
<!--- insert interview review --->

	<cfparam name="Form.ReviewClass" type="any" default="">

	<cfparam name="Form.Int_Initial" type="any" default="">
	<cfset cd = "#evaluate("Form.Int_Initial")#">
	
	<cfif cd neq "">
	
	 <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId,SelectDescription,
			 SelectParameter,
			 SearchStage)
		 VALUES ('#URL.ID#', 'Interview', 'Int_Initial', 'Initial Interview', '#cd#', '4')
	  </cfquery>	 
			
	</cfif>
	
<!--- ---------------------------- --->			
<!--- insert assessment requirment --->

	<cfquery name="SourceList" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Source
		WHERE    AllowAssessment = 1		
    </cfquery>	
		
	<cfloop query="SourceList">

		<cfparam name="Form.Assessed#Source#Operator" type="any" default="ANY">
			
		<cfset cd = evaluate("Form.Assessed#Source#Operator")>		
								
		<cfif cd eq "ALL">
		
			<cfquery name="Check" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   RosterSearchLine
			 WHERE  SearchId = '#URL.ID#'
			  AND   SearchClass = 'Assessed#source#'		 
		    </cfquery>
					
		    <cfif Check.recordcount gte "2">
						
				 <cfquery name="Insert" 
			        datasource="AppsSelection" 
			        username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			        INSERT INTO RosterSearchLine
			         (SearchId,
					 SearchClass,
					 SelectId,
					 SelectDescription,
					 SelectParameter,
					 SearchStage)
					 VALUES
					 ('#URL.ID#', 
					 'Assessed#Source#Operator', 
					 '#cd#', 
					 'Require all selected', 
					 '#cd#', 
					 '4')
				  </cfquery>	
			  
			 </cfif>
			 
		<cfelse>
		
			 <cfquery name="Insert" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId,
				 SelectDescription,
				 SelectParameter,
				 SearchStage)
				 VALUES
				 ('#URL.ID#', 
				 'Assessed#Source#Operator', 
				 '#cd#', 
				 'Require any selected', 
				 '#cd#', 
				 '4')
			  </cfquery>			   
				
		</cfif>	
	
	</cfloop>	
	
	<cfparam name="Form.SelfAssessmentOperator" type="any" default="ANY">
			
		<cfset cd = evaluate("Form.SelfAssessmentOperator")>		
								
		<cfif cd eq "ALL">
		
			<cfquery name="Check" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   RosterSearchLine
			 WHERE  SearchId = '#URL.ID#'
			  AND   SearchClass = 'SelfAssessment'		 
		    </cfquery>
					
		    <cfif Check.recordcount gte "2">
						
				 <cfquery name="Insert" 
			        datasource="AppsSelection" 
			        username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			        INSERT INTO RosterSearchLine
			         (SearchId,
					 SearchClass,
					 SelectId,
					 SelectDescription,
					 SelectParameter,
					 SearchStage)
					 VALUES
					 ('#URL.ID#', 
					 'SelfAssessmentOperator', 
					 '#cd#', 
					 'Require all selected', 
					 '#cd#', 
					 '4')
				  </cfquery>	
			  
			 </cfif>
			 
		<cfelse>
		
			 <cfquery name="Insert" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId,
				 SelectDescription,
				 SelectParameter,
				 SearchStage)
				 VALUES
				 ('#URL.ID#', 
				 'SelfAssessmentOperator', 
				 '#cd#', 
				 'Require any selected', 
				 '#cd#', 
				 '4')
			  </cfquery>			   
				
		</cfif>	
		   	
<!--- ---------------------- --->			
<!--- insert criteria name --->

<cfparam name="Form.Name" type="any" default="">

       <cfif Form.Name neq "">

  	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#','Name','#Form.Name#','#Form.Name#','4')
    </cfquery>	
	
	</cfif>
			
		
<!--- ---------------------- --->			
<!--- insert criteria gender --->

<cfparam name="Form.Gender" type="any" default="">

       <cfif Form.Gender eq "F">
	     <cfset val = "Female">
	   <cfelseif Form.Gender eq "M">	 
	      <cfset val = "Male">
	   <cfelse>
	      <cfset val = "Both"> 	  
	   </cfif>

  	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#',
	       'Gender', 
          '#Form.Gender#','#val#','4')
    </cfquery>
	
<!--- ---------------------- --->			
<!--- insert age gender --->

<cfparam name="Form.AgeFrom"  type="any" default="0">
<cfparam name="Form.AgeUntil" type="any" default="0">

<cfif (Form.AgeFrom eq "0" and Form.AgeUntil eq "0") or (Form.AgeFrom eq "" and Form.AgeUntil eq "")>

   <!--- age range --->

<cfelse>

  	  <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#','AgeFrom','#Form.AgeFrom#','#Form.AgeFrom#','4')
      </cfquery>
	
  	  <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#','AgeUntil','#Form.AgeUntil#','#Form.AgeUntil#','4')
      </cfquery>	
	  
</cfif>	  
	
<!--- ---------------------- --->			
<!--- insert total work --->

<cfparam name="Form.WorkYears" type="any" default="">

       <cfif Form.WorkYears neq "">

  	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#','WorkExperience','#Form.WorkYears#','#Form.WorkYears#','4')
    	</cfquery>
	
		</cfif>
		
<!--- ----------------------------------- --->		
<!---   insert topic/questions operator   --->

<cfparam name="Form.Topic" type="any" default="">	
	
<cfif Form.Topic neq "">
	
	<cfif Form.TopicStatus eq "0">
	    <cfset top = "Do not match">
	<cfelse>
	    <cfset top = "Match all">
	</cfif>
	
	 <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,SearchClass,SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#','TopicOperator','#Form.TopicStatus#','#top#','4')
	       </cfquery>
	
	<cfloop index="rec" from="1" to="#Form.Topic#">
	
	    <cfparam name="Form.TopicSelect_#rec#" default="">	
		<cfset select    = Evaluate("FORM.Topicselect_" & #Rec#)>
		
		<cfif select neq "">
		
			<cfset topicid      = Evaluate("FORM.topic_" & #Rec#)>
			<cfset description  = Evaluate("FORM.topicdes_" & #Rec#)>
			<cfif Len(description) gt 200>
			     <cfset description = Left(description, 200)>
			</cfif>
			<cfset parameter = Evaluate("FORM.topicParameter_" & #Rec#)>
			
			 <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	        (SearchId,SearchClass,SelectId,SelectParameter, SelectDescription,SearchStage)
	        VALUES ('#URL.ID#','Topic','#topicid#','#parameter#','#description#','4')
	        </cfquery>
		
		</cfif>
	
	</cfloop>
	
</cfif>	

<!--- ----------------------------------- --->		
<!--- insert criteria language operator --->

<cfparam name="Form.LanguageStatus" type="any" default="">

   	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription, SearchStage)
        VALUES ('#URL.ID#',
	       'LanguageOperator', 
          '#Form.LanguageStatus#','#Form.LanguageStatus#','4')
       </cfquery>
	   
<cfparam name="Form.LanguageLevel" type="any" default="">

       <cfif Form.LanguageLevel eq "1">

	   	   <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#',
		       'LanguageLevel', 
	          '#Form.LanguageLevel#','High','4') 
	       </cfquery>	
	   
	   </cfif>   
	      
<cfparam name="Form.OwnerKeyWord" type="any" default="0">

      	   	   <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,
			 SearchClass,
			 SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#',
		       'OwnerKeyWord', 
	          '#Form.OwnerKeyWord#','#Form.OwnerKeyWord#','4') 
	       </cfquery>		   
	     
		
<!--- insert language entries --->

<cfparam name="Form.Language" type="any" default="">

<cfloop index="Item" 
        list="#Form.Language#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Language', 
          '#Item#','4')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RosterSearchLine
	 SET SelectDescription = S.LanguageName
	 FROM RosterSearchLine INNER JOIN Ref_Language S ON RosterSearchLine.SelectId =  S.LanguageId 
	 WHERE RosterSearchLine.SearchId = '#URL.ID#'
	 AND   RosterSearchLine.SearchClass = 'Language'
    </cfquery>	
	
</cfloop>	

<!--- ----------------------------------- --->		
<!--- insert criteria mission operator --->

<cfparam name="Form.MissionStatus" type="any" default="">

   	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId, SelectDescription, SearchStage)
        VALUES ('#URL.ID#','MissionOperator','#Form.MissionStatus#','#Form.MissionStatus#','4')
       </cfquery>
	   
<!--- insert mission preference entries--->

<cfparam name="Form.Mission" type="any" default="">

<cfloop index="Item" 
        list="#Form.Mission#" 
        delimiters="',">
		
			<cfquery name="Insert" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
      VALUES ('#URL.ID#',
	       'Mission', 
          '#Item#','4')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RosterSearchLine
	 SET    SelectDescription = S.Mission
	 FROM   RosterSearchLine INNER JOIN ApplicantMission S ON RosterSearchLine.SelectId =  S.Mission
	 WHERE  RosterSearchLine.SearchId = '#URL.ID#'
	 AND    RosterSearchLine.SearchClass = 'Mission'
    </cfquery>	
	
</cfloop>	

<!--- ------------------------------------ --->		
<!--- insert criteria nationality operator --->

<cfparam name="Form.NationalityStatus" type="any" default="">

  	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
        VALUES ('#URL.ID#','NationalityOperator','#Form.NationalityStatus#','#Form.NationalityStatus#','4')
      </cfquery>
	  
   
<cfparam name="Form.NationalityMode" type="any" default="">

       <cfif Form.NationalityMode eq "1">

	   	   <cfquery name="Insert" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        INSERT INTO RosterSearchLine
	         (SearchId,SearchClass,SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#','NationalityMode','#Form.NationalityMode#','Exclude','4') 
	       </cfquery>	
	   
	   </cfif>   	  
   
<!--- insert nationality entries --->

<cfparam name="Form.Nationality" type="any" default="">

<cfloop index="Item" 
        list="#Form.Nationality#" 
        delimiters="' ,">
		
			<cfquery name="Insert" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RosterSearchLine
         (SearchId,SearchClass,SelectId, SearchStage)
      VALUES ('#URL.ID#','Nationality','#Item#','4')
    </cfquery>
	
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RosterSearchLine
	 SET    SelectDescription = S.Name
	 FROM   RosterSearchLine INNER JOIN System.dbo.Ref_Nation S ON RosterSearchLine.SelectId =  S.Code 
	 WHERE  RosterSearchLine.SearchId    = '#URL.ID#'
	 AND    RosterSearchLine.SearchClass = 'Nationality'
    </cfquery>
</cfloop>	

 	  
<!--- ------------------------------------ --->		
<!--- insert keywords -------------------- --->

<cfparam name="Form.BackgroundStatus" type="any" default="">
 
  	   <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
                 (SearchId,SearchClass,SelectId,SelectDescription,SearchStage)
        VALUES   ('#URL.ID#','BackgroundOperator','#Form.BackgroundStatus#','#Form.BackgroundStatus#','4')
      </cfquery>	  
  	  
<cfparam name="Form.Background" type="any" default="">

		<cfset No = 0>

		<cfloop index="Item" list="#Form.Background#" delimiters=";">
		
		<cfset No = No+1>
		
		<cftry>
				
			<cfquery name="Insert" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     	INSERT INTO RosterSearchLine
		        	 (SearchId,
					 SearchClass,
					 SelectId, 
					 SelectDescription, 
					 SearchStage)
		        VALUES ('#URL.ID#',
			       		'Background', 
		          		'keyword#No#',
						'#trim(Item)#',
						'4')
		    </cfquery>
	
	   <cfcatch>
	   		  		    
			    <cf_message return="back" message="Your search could not be completed. <br>Please check your recorded keywords if these are properly separated by a semi-colon [;].">
			    <cfabort>
	   
	   </cfcatch>
	   
	   </cftry>
		
</cfloop>	

<cfif Form.BackgroundStatus eq "ALL">

<cfloop index="itm" from="1" to="3">

	<cfparam name="Form.Background#itm#" type="any" default="">
	
	<cfset bckground = Evaluate("FORM.Background" & #itm#)>
	
	<cfset No = 0>
	
	    <cfloop index="Item" 
	        list="#bckground#" 
	        delimiters=";">
			
			   <cfset No = No+1>
			   
			   <cftry>
			   					
				<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO RosterSearchLine
			         (SearchId,
					  SearchClass,
					  SelectId, 
					  SelectDescription, 
					  SearchStage)
			      VALUES ('#URL.ID#',
				      'Background#itm#', 
			          'keyword#No#',
					  '#trim(Item)#',
					  '4')
			    </cfquery>
				
				 <cfcatch>
	   		  		    
				    <cf_message return="back" message="Your search could not be completed. <br>Please check your recorded keywords if these are properly separated by a semi-colon [;].">
			  		<cfabort>
	   
			   </cfcatch>
	   
	   		</cftry>
			
	</cfloop>	

</cfloop>

</cfif>		

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<cflocation url="Query/QuerySearch.cfm?mode=#url.mode#&docno=#url.docno#&ID=#URL.ID#&mid=#mid#" addtoken="No">