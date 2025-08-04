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
<!--- This template record by default the behaviors that will be a basis for rating in the full evaluation.

Assuming that ePas Contracts have been already created 
operational=true
and 
actionstatus=0 (only at the initiation stage)
valid ones;
What I understand is that we will run this on July 1st.
So all the item (questions) will be populated.

This is to say that if a person moves after July 1st, then the person will be evaluated based on the functionNo
he/she had at that date.

---->



<cfquery name="qContract" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    Select ContractId, FunctionNo 
    from Contract C
    Where 
	C.ContractId='#EventId#'
    and	C.Operational='1'  
 </cfquery>
 
 
<cfloop Query="qContract">

<cftry>
        <cfquery name="IContract" 
        datasource="AppsEPAS" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            INSERT INTO ContractBehavior
                (ContractId,BehaviorCode,BehaviorDescription,PriorityCode)
            SELECT '#QContract.ContractId#', Code,BehaviorMemo,'P01'
                FROM         Ref_BehaviorFunction INNER JOIN
                                  Ref_Behavior ON Ref_BehaviorFunction.BehaviorGroup = Ref_Behavior.BehaviorGroup
                            WHERE FunctionNo = '#QContract.FunctionNo#'
         </cfquery>
        
<cfcatch></cfcatch>		
 </cftry>    

        
        <!---Then we set the action status ="1" for the contract to indicate that the preparation phase has been done --->

        <cfquery name="UpdateContract" 
        datasource="AppsEPAS" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            Update Contract
            set ActionStatus='2'
            Where ContractId='#QContract.ContractId#' 
         </cfquery>

        

   
</cfloop>