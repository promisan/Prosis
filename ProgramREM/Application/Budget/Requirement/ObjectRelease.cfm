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
<cfparam name="url.editionid" default="0">

<!--- based on the defined funds and the enabled OE codes for the class we show a list of OE and
allow the user to submit a date until which the budget will need to be release per plan target 



then based on the submission we loop through the requirements and set the AmountAllotment based on the date

if no detail the based on the date
if details based on the pro-rata
if the current amount is higher we do not touch it

--->

