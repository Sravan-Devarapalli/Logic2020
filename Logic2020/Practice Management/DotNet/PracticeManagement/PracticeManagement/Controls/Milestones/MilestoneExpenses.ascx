﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MilestoneExpenses.ascx.cs"
    Inherits="PraticeManagement.Controls.Milestones.MilestoneExpenses" %>
<%@ Import Namespace="DataTransferObjects" %>
<%@ Register TagPrefix="asp" Namespace="PraticeManagement.Controls.Generic.Buttons"
    Assembly="PraticeManagement" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:UpdateProgress ID="updProgress" runat="server" AssociatedUpdatePanelID="updProjectExpenses">
    <ProgressTemplate>
        <asp:Image ID="img" runat="server" ImageUrl="~/Images/ajax-loader.gif" />
    </ProgressTemplate>
</asp:UpdateProgress>
<asp:UpdatePanel ID="updProjectExpenses" runat="server" UpdateMode="Always">

    <ContentTemplate>
        <asp:HiddenField ID="hdnEstAmount" runat="server" />
        <asp:HiddenField ID="hdnActAmount" runat="server" />
        <asp:GridView ID="gvProjectExpenses" runat="server" DataSourceID="odsProjectExpenses"
            EmptyDataText="No project expenses for this milestone" ShowFooter="True" AutoGenerateColumns="False"
            AlternatingRowStyle-BackColor="#e0e0e0" DataKeyNames="Id" OnRowDataBound="gvProjectExpenses_OnRowDataBound"
            FooterStyle-Font-Bold="true" FooterStyle-VerticalAlign="Top" CssClass="CompPerfTable WholeWidth"
            GridLines="None" BackColor="White" OnRowUpdating="gvProjectExpenses_OnRowUpdating">
            <AlternatingRowStyle CssClass="alterrow" />
            <RowStyle CssClass="BackGroundColorWhite" />
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Name
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkExpense" runat="server" ExpenseId='<%# ((ProjectExpense)Container.DataItem).Id%>' ToolTip='<%# ((ProjectExpense)Container.DataItem).HtmlEncodedName%>'
                            OnClick="lnkExpense_OnClick" Text='<%# ((ProjectExpense)Container.DataItem).HtmlEncodedName%>' ActAmount='<%# ((ProjectExpense)Container.DataItem).Amount!=null? ((ProjectExpense)Container.DataItem).Amount:0%>' EstAmount='<%# ((ProjectExpense)Container.DataItem).ExpectedAmount%>'
                            StartDate='<%# ((ProjectExpense)Container.DataItem).StartDate%>' EndDate='<%# ((ProjectExpense)Container.DataItem).EndDate%>'></asp:LinkButton>

                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="tbEditName" runat="server" Text='<%# Bind("Name") %>' ValidationGroup="ProjectExpensesEdit" ExpenseId='<%# ((ProjectExpense)Container.DataItem).Id%>' />
                        <asp:RequiredFieldValidator ID="valReqName" runat="server" ControlToValidate="tbEditName"
                            ValidationGroup="ProjectExpensesEdit" ErrorMessage="Expense name is required"
                            Text="*" />
                    </EditItemTemplate>
                    <FooterTemplate>
                        Total
                        <hr />
                        <table>
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="tbEditName" runat="server" ValidationGroup="ProjectExpensesAdd"
                                        CssClass="textCenter" />
                                    <asp:RequiredFieldValidator ID="valReqName" ValidationGroup="ProjectExpensesAdd"
                                        runat="server" ControlToValidate="tbEditName" ErrorMessage="Expense name is required"
                                        Text="*" />
                                </td>
                            </tr>
                        </table>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Start Date">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Start Date
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((DateTime) ((ProjectExpense) Container.DataItem).StartDate).ToString("MM/dd/yyyy") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <table>
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStartDate" runat="server" Text='<%# Bind("StartDate", "{0:MM/dd/yyyy}") %>'
                                        ValidationGroup="ProjectExpensesEdit" CssClass="Width80Px" />
                                </td>
                                <td>
                                    <asp:HyperLink ID="lnkCalendarStartDate" runat="server" ImageUrl="~/Images/calendar.gif"
                                        NavigateUrl="#"></asp:HyperLink>
                                    <ajaxToolkit:CalendarExtender ID="clStartDate" runat="server" BehaviorID="bhclStartDate"
                                        Format='<%# PraticeManagement.Constants.Formatting.EntryDateFormat %>' PopupPosition="BottomLeft"
                                        PopupButtonID="lnkCalendarStartDate" TargetControlID="txtStartDate" />
                                    <asp:RequiredFieldValidator ID="valReqStartDate" ValidationGroup="ProjectExpensesEdit"
                                        runat="server" ControlToValidate="txtStartDate" ErrorMessage="Start Date is required"
                                        Text="*" />
                                    <asp:RegularExpressionValidator ID="rgStartDateFormat" runat="server" ControlToValidate="txtStartDate"
                                        ToolTip="The Start Date has an incorrect format. It must be 'MM/dd/yyyy'." ErrorMessage="The Start Date has an incorrect format. It must be 'MM/dd/yyyy'."
                                        ValidationExpression="^([1-9]|0[1-9]|1[012])[/]([1-9]|0[1-9]|[12][0-9]|3[01])[/][0-9]{4}$"
                                        ValidationGroup='ProjectExpensesEdit'>*</asp:RegularExpressionValidator>
                                    <asp:CustomValidator ID="cstStartDateShouldbewithinProjectPeriod" runat="server"
                                        ValidationGroup="ProjectExpensesEdit" ErrorMessage="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."
                                        Text="*" ToolTip="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <br />
                        <hr />
                        <table class="fontNormal">
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStartDate" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        CssClass="Width80Px" />
                                </td>
                                <td>
                                    <asp:HyperLink ID="lnkCalendarStartDate" runat="server" ImageUrl="~/Images/calendar.gif"
                                        NavigateUrl="#"></asp:HyperLink>
                                    <ajaxToolkit:CalendarExtender ID="clStartDate" runat="server" BehaviorID="bhclStartDate"
                                        Format='<%# PraticeManagement.Constants.Formatting.EntryDateFormat %>' PopupPosition="BottomLeft"
                                        PopupButtonID="lnkCalendarStartDate" TargetControlID="txtStartDate" />
                                    <asp:RequiredFieldValidator ID="valReqStartDate" ValidationGroup="ProjectExpensesAdd"
                                        runat="server" ControlToValidate="txtStartDate" ErrorMessage="Start Date is required"
                                        Text="*" />
                                    <asp:RegularExpressionValidator ID="rgStartDateFormat" runat="server" ControlToValidate="txtStartDate"
                                        ToolTip="The Start Date has an incorrect format. It must be 'MM/dd/yyyy'." ErrorMessage="The Start Date has an incorrect format. It must be 'MM/dd/yyyy'."
                                        ValidationExpression="^([1-9]|0[1-9]|1[012])[/]([1-9]|0[1-9]|[12][0-9]|3[01])[/][0-9]{4}$"
                                        ValidationGroup='ProjectExpensesAdd'>*</asp:RegularExpressionValidator>
                                    <asp:CustomValidator ID="cstStartDateShouldbewithinProjectPeriod" runat="server"
                                        ValidationGroup="ProjectExpensesEdit" ErrorMessage="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."
                                        Text="*" ToolTip="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="End Date">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            End Date
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((DateTime) ((ProjectExpense) Container.DataItem).EndDate).ToString("MM/dd/yyyy") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <table>
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEndDate" runat="server" Text='<%# Bind("EndDate", "{0:MM/dd/yyyy}") %>'
                                        ValidationGroup="ProjectExpensesEdit" CssClass="Width80Px" />
                                </td>
                                <td>
                                    <asp:HyperLink ID="lnkCalendarEndDate" runat="server" ImageUrl="~/Images/calendar.gif"
                                        NavigateUrl="#"></asp:HyperLink>
                                    <ajaxToolkit:CalendarExtender ID="clEndDate" runat="server" BehaviorID="bhclEndDate"
                                        Format='<%# PraticeManagement.Constants.Formatting.EntryDateFormat %>' PopupPosition="BottomLeft"
                                        PopupButtonID="lnkCalendarEndDate" TargetControlID="txtEndDate" />
                                    <asp:CustomValidator ID="cstEndShouldBeGreater" runat="server" Text="*" ErrorMessage="End date must be greater than Start date"
                                        ToolTip="End date must be greater than Start date" Display="Dynamic" ValidationGroup="ProjectExpensesEdit"></asp:CustomValidator>
                                    <asp:RequiredFieldValidator ID="valReqEndDate" ValidationGroup="ProjectExpensesEdit"
                                        runat="server" ControlToValidate="txtEndDate" ErrorMessage="End Date is required"
                                        Text="*" Display="Dynamic" />
                                    <asp:RegularExpressionValidator ID="rgEndDateFormat" runat="server" ControlToValidate="txtEndDate"
                                        ToolTip="The End Date has an incorrect format. It must be 'MM/dd/yyyy'." ErrorMessage="The End Date has an incorrect format. It must be 'MM/dd/yyyy'."
                                        ValidationExpression="^([1-9]|0[1-9]|1[012])[/]([1-9]|0[1-9]|[12][0-9]|3[01])[/][0-9]{4}$"
                                        ValidationGroup='ProjectExpensesEdit'>*</asp:RegularExpressionValidator>
                                    <asp:CustomValidator ID="cstEndDateShouldbewithinProjectPeriod" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        ErrorMessage="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."
                                        Display="Dynamic" Text="*" ToolTip="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."></asp:CustomValidator>
                                    <asp:CustomValidator ID="custLockdown" runat="server" Text="*" ValidationGroup="ProjectExpensesEdit"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <br />
                        <hr />
                        <table class="fontNormal">
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEndDate" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        CssClass="Width80Px" />
                                </td>
                                <td>
                                    <asp:HyperLink ID="lnkCalendarEndDate" runat="server" ImageUrl="~/Images/calendar.gif"
                                        NavigateUrl="#"></asp:HyperLink>
                                    <ajaxToolkit:CalendarExtender ID="clEndDate" runat="server" BehaviorID="bhclEndDate"
                                        Format='<%# PraticeManagement.Constants.Formatting.EntryDateFormat %>' PopupPosition="BottomLeft"
                                        PopupButtonID="lnkCalendarEndDate" TargetControlID="txtEndDate" />
                                    <asp:RequiredFieldValidator ID="valReqEndDate" ValidationGroup="ProjectExpensesAdd"
                                        runat="server" ControlToValidate="txtEndDate" ErrorMessage="End Date is required"
                                        Text="*" />
                                    <asp:RegularExpressionValidator ID="rgEndDateFormat" runat="server" ControlToValidate="txtEndDate"
                                        ToolTip="The End Date has an incorrect format. It must be 'MM/dd/yyyy'." ErrorMessage="The End Date has an incorrect format. It must be 'MM/dd/yyyy'."
                                        ValidationExpression="^([1-9]|0[1-9]|1[012])[/]([1-9]|0[1-9]|[12][0-9]|3[01])[/][0-9]{4}$"
                                        ValidationGroup='ProjectExpensesAdd'>*</asp:RegularExpressionValidator>
                                    <asp:CustomValidator ID="cstEndShouldBeGreater" runat="server" Text="*" ErrorMessage="End date shuould be greater than Start date"
                                        ToolTip="End date shuould be greater than Start date" ValidationGroup="ProjectExpensesEdit"></asp:CustomValidator>
                                    <asp:CustomValidator ID="cstEndDateShouldbewithinProjectPeriod" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        ErrorMessage="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."
                                        Text="*" ToolTip="You have attempted to add an expense that was for a period of time outside of the start and end dates for the milestone. Please readjust the start and end dates for the expense line item."></asp:CustomValidator>
                                    <asp:CustomValidator ID="custLockdown" runat="server" Text="*" ValidationGroup="ProjectExpensesEdit"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expense Type">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Expense Type
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((ProjectExpense) Container.DataItem).Type.Name %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <table>
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlExpenseType" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        CssClass="WholeWidth">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ID="reqExpenseType" runat="server" ValidationGroup="ProjectExpensesEdit"
                                        InitialValue="" ControlToValidate="ddlExpenseType" EnableClientScript="False"
                                        ErrorMessage="The Expense type is required." SetFocusOnError="True" ToolTip="The Expense type is required.">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <br />
                        <hr />
                        <table>
                            <tr>
                                <td class="Width18Percent">&nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlExpense" runat="server" ValidationGroup="ProjectExpensesAdd"
                                        CssClass="WholeWidth">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ID="reqExpense" runat="server" ValidationGroup="ProjectExpensesAdd"
                                        InitialValue="" ControlToValidate="ddlExpense" ErrorMessage="The Expense type is required."
                                        SetFocusOnError="True" ToolTip="The Expense type is required.">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Estimated Expense
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((PracticeManagementCurrency)((ProjectExpense)Container.DataItem).ExpectedAmount).ToString()%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="tbEditExpAmount" runat="server" Text='<%# Bind("ExpectedAmount") %>'
                            ValidationGroup="ProjectExpensesEdit" CssClass="Width80Px" />
                        <asp:RequiredFieldValidator ID="valReqExpAmount" ValidationGroup="ProjectExpensesEdit"
                            runat="server" ControlToValidate="tbEditExpAmount" ErrorMessage="Expected Expense amount is required"
                            Text="*" />
                        <asp:RangeValidator ID="valRangeExpAmout" ValidationGroup="ProjectExpensesEdit" runat="server"
                            ControlToValidate="tbEditExpAmount" Type="Double" MinimumValue="0.01" MaximumValue="1000000000"
                            ErrorMessage="Amount should be positive real" Text="*" />
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <asp:Label ID="lblTotalExpAmount" runat="server" Text="$0" />
                        <hr />
                        <asp:TextBox ID="tbEditExpAmount" runat="server" ValidationGroup="ProjectExpensesAdd" />
                        <asp:RequiredFieldValidator ID="valReqExpAmount" ValidationGroup="ProjectExpensesAdd"
                            runat="server" ControlToValidate="tbEditExpAmount" ErrorMessage="Expected Expense amount is required"
                            Text="*" />
                        <asp:RangeValidator ID="valRangeExpAmout" ValidationGroup="ProjectExpensesAdd" runat="server"
                            ControlToValidate="tbEditExpAmount" Type="Double" MinimumValue="0.01" MaximumValue="1000000000"
                            ErrorMessage="Expected Amount should be positive real" Text="*" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Actual Expense
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((ProjectExpense) Container.DataItem).Amount!=null? ((PracticeManagementCurrency) ((ProjectExpense) Container.DataItem).Amount).ToString() : string.Empty%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="tbEditAmount" runat="server" Text='<%# Bind("Amount") %>' ValidationGroup="ProjectExpensesEdit"
                            CssClass="Width80Px" />
                        <asp:RangeValidator ID="valRangeAmout" ValidationGroup="ProjectExpensesEdit" runat="server"
                            ControlToValidate="tbEditAmount" Type="Double" MinimumValue="0.00" MaximumValue="1000000000"
                            ErrorMessage="Amount should be positive real" Text="*" />
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <asp:Label ID="lblTotalAmount" runat="server" Text="$0" />
                        <hr />
                        <asp:TextBox ID="tbEditAmount" runat="server" ValidationGroup="ProjectExpensesAdd" />
                        <asp:RangeValidator ID="valRangeAmout" ValidationGroup="ProjectExpensesAdd" runat="server"
                            ControlToValidate="tbEditAmount" Type="Double" MinimumValue="0.00" MaximumValue="1000000000"
                            ErrorMessage="Amount should be positive real" Text="*" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Variance
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((PracticeManagementCurrency) ((ProjectExpense) Container.DataItem).Difference).ToString() %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <%# ((PracticeManagementCurrency) ((ProjectExpense) Container.DataItem).Difference).ToString() %>
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <asp:Label ID="lblVariance" runat="server" Text="$0" />
                        <hr />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reimbursed, %">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Reimbursed
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# (string.Format("{0:0}",((ProjectExpense) Container.DataItem).Reimbursement)) %>%
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="tbEditReimbursement" runat="server" Text='<%# Bind("Reimbursement") %>'
                            ValidationGroup="ProjectExpensesEdit" Width="80px" />
                        <asp:RequiredFieldValidator ID="valReqReimbursement" ValidationGroup="ProjectExpensesEdit"
                            runat="server" ControlToValidate="tbEditReimbursement" ErrorMessage="Expense reimbursement is required"
                            Text="*" />
                        <asp:RangeValidator ID="valRangeReimbursement" ValidationGroup="ProjectExpensesEdit"
                            runat="server" ControlToValidate="tbEditReimbursement" Type="Double" MinimumValue="0"
                            MaximumValue="500" ErrorMessage="Reimbursement should be positive real between 0.0 and 500.00"
                            Text="*" />
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <asp:Label ID="lblTotalReimbursed" runat="server" Text="0%" />
                        <hr />
                        <asp:TextBox ID="tbEditReimbursement" runat="server" CssClass="Width80Px" ValidationGroup="ProjectExpensesAdd" />
                        <asp:RequiredFieldValidator ID="valReqReimbursement" ValidationGroup="ProjectExpensesAdd"
                            runat="server" ControlToValidate="tbEditReimbursement" ErrorMessage="Expense reimbursement is required"
                            Text="*" />
                        <asp:RangeValidator ID="valRangeReimbursement" ValidationGroup="ProjectExpensesAdd"
                            runat="server" ControlToValidate="tbEditReimbursement" Type="Double" MinimumValue="0"
                            MaximumValue="500" ErrorMessage="Reimbursement should be positive real between 0.0 and 500.00"
                            Text="*" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reimbursed, $">
                    <HeaderTemplate>
                        <div class="ie-bg NoBorder">
                            Reimbursed
                        </div>
                    </HeaderTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <%# ((PracticeManagementCurrency) ((ProjectExpense)Container.DataItem).ReimbursementAmount).ToString() %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <%# ((PracticeManagementCurrency)((ProjectExpense)Container.DataItem).ReimbursementAmount).ToString()%>
                    </EditItemTemplate>
                    <FooterStyle CssClass="textCenter" />
                    <FooterTemplate>
                        <asp:Label ID="lblTotalReimbursementAmount" runat="server" Text="$0" />
                        <hr />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False" FooterStyle-VerticalAlign="Bottom" FooterStyle-Font-Bold="false">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="False" CommandName="Edit"
                            Text="Edit" />
                    </ItemTemplate>
                    <ItemStyle CssClass="textCenter" />
                    <EditItemTemplate>
                        <asp:LinkButton ID="lnkUpdate" runat="server" ValidationGroup="ProjectExpensesEdit"
                            CausesValidation="True" CommandName="Update" Text="Update" />
                        &nbsp;
                        <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                            Text="Cancel" />
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:ShadowedTextButton ID="btnAddExpense" runat="server" Text="Add Expense" CssClass="add-btn"
                            CommandName="Insert" OnClick="lnkAdd_OnClick" ValidationGroup="ProjectExpensesAdd" />

                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <ItemStyle CssClass="textCenter" />
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDelete" runat="server" CausesValidation="False" CommandName="Delete"
                            Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this expense record?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <AlternatingRowStyle CssClass="bgColor_e0e0e0" />
        </asp:GridView>
        <asp:ValidationSummary ID="vsProjectExpensesEdit" ValidationGroup="ProjectExpensesEdit"
            runat="server" />
        <asp:ValidationSummary ID="vsProjectExpensesAdd" ValidationGroup="ProjectExpensesAdd"
            runat="server" />
        <asp:ObjectDataSource ID="odsProjectExpenses" runat="server" DataObjectTypeName="DataTransferObjects.ProjectExpense"
            SelectMethod="ProjectExpensesForMilestone" UpdateMethod="UpdateProjectExpense"
            OnSelecting="odsProjectExpenses_OnSelecting" InsertMethod="AddProjectExpense"
            DeleteMethod="RemoveProjectExpense" TypeName="PraticeManagement.Controls.ProjectExpenses.ProjectExpenseHelper">
            <SelectParameters>
                <asp:Parameter Name="milestoneId" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:HiddenField ID="hdnTempField" runat="server" />
        <AjaxControlToolkit:ModalPopupExtender ID="mpeMonthlyExpense" runat="server"
            TargetControlID="hdnTempField" CancelControlID="btnCancelMonthlyExpense"
            BackgroundCssClass="modalBackground" PopupControlID="pnlMonthlyExpense"
            DropShadow="false" />
        <asp:Panel ID="pnlMonthlyExpense" Style="display: none;"
            runat="server" CssClass="Expense_MonthlyExpensePnl">
            <table class="WholeWidth Padding5">
                <tr>
                    <td class="WholeWidth">
                        <table class="WholeWidthWithHeight">
                            <tr class="bgColor_F5FAFF">
                                <td class="MonthlyRevenue_Name">
                                    <asp:Label ID="lblExpenseName" runat="server"></asp:Label>
                                </td>
                                <td class="MonthlyRevenue_Name">
                                    <asp:Label ID="lblPeriod" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="WholeWidth" colspan="2">
                                    <div>
                                        <asp:Repeater ID="repMonthlyExpense" runat="server">
                                            <HeaderTemplate>
                                                <div>
                                                    <table id="tblMonthlyExpense" class="tablesorter TimePeriodByproject WholeWidth ">
                                                        <thead>
                                                            <tr>
                                                                <th class="ProjectColoum no-wrap">Month
                                                                </th>
                                                                <th class="Width110Px no-wrap">Estimated Expense
                                                                </th>
                                                                <th class="Width110Px no-wrap">Actual Expense
                                                                </th>
                                                                <th class="Width170PxImp">Variance
                                                                </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr runat="server" id="repItem">
                                                    <td>
                                                        <asp:Label ID="lblMonth" runat="server" StartDate='<%#Eval("StartDate") %>' EndDate='<%#Eval("EndDate") %>' Text=' <%# ((DateTime)Eval("StartDate")).ToString(Constants.Formatting.CompPerfMonthYearFormat)%>'
                                                            ExpenseId='<%#Eval("Id") %>' ProjectExpenseId='<%#Eval("ProjectExpenseId") %>'></asp:Label>
                                                    </td>
                                                    <td class="no-wrap">
                                                        <asp:TextBox ID="txtEstExpense" runat="server" Text='<%# ((Decimal)Eval("EstimatedExpense")).ToString("##############0.##")%>'></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="valReqEstExpense" ValidationGroup="MonthlyExpenses"
                                                            runat="server" ControlToValidate="txtEstExpense" ErrorMessage="Expected Expense amount is required"
                                                            Text="*" />
                                                        <asp:RangeValidator ID="valRangeEstExpense" ValidationGroup="MonthlyExpenses" runat="server"
                                                            ControlToValidate="txtEstExpense" Type="Double" MinimumValue="0.01" MaximumValue="1000000000"
                                                            ErrorMessage="Expected Amount should be positive real" Text="*" />
                                                    </td>
                                                    <td class="no-wrap">
                                                        <asp:TextBox ID="txtActExpense" runat="server" Text='<%#(Decimal?)Eval("ActualExpense")!=null? ((Decimal?)Eval("ActualExpense")).Value.ToString("##############0.##"):string.Empty%>'></asp:TextBox>
                                                        <asp:RangeValidator ID="valRangeActExpense" ValidationGroup="MonthlyExpenses" runat="server"
                                                            ControlToValidate="txtActExpense" Type="Double" MinimumValue="0.00" MaximumValue="1000000000"
                                                            ErrorMessage="Actual Amount should be positive real" Text="*" />
                                                    </td>
                                                    <td>
                                                        <%# ((Decimal)Eval("Variance")).ToString("###,###,###,###,##0.##")%>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <AlternatingItemTemplate>
                                                <tr runat="server" id="repAltItem">
                                                    <td>
                                                        <asp:Label ID="lblMonth" runat="server" StartDate='<%#(DateTime)Eval("StartDate") %>' EndDate='<%#Eval("EndDate") %>' Text=' <%# ((DateTime)Eval("StartDate")).ToString(Constants.Formatting.CompPerfMonthYearFormat)%>'
                                                            ExpenseId='<%#Eval("Id") %>' ProjectExpenseId='<%#Eval("ProjectExpenseId") %>'></asp:Label>
                                                    </td>
                                                    <td class="no-wrap">
                                                        <asp:TextBox ID="txtEstExpense" runat="server" Text='<%# ((Decimal)Eval("EstimatedExpense")).ToString("##############0.##")%>'></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="valReqEstExpense" ValidationGroup="MonthlyExpenses"
                                                            runat="server" ControlToValidate="txtEstExpense" ErrorMessage="Expected Expense amount is required"
                                                            Text="*" />
                                                        <asp:RangeValidator ID="valRangeEstExpense" ValidationGroup="MonthlyExpenses" runat="server"
                                                            ControlToValidate="txtEstExpense" Type="Double" MinimumValue="0.01" MaximumValue="1000000000"
                                                            ErrorMessage="Expected Amount should be positive real" Text="*" />
                                                    </td>
                                                    <td class="no-wrap">
                                                        <asp:TextBox ID="txtActExpense" runat="server" Text='<%# (Decimal?)Eval("ActualExpense")!=null? ((Decimal?)Eval("ActualExpense")).Value.ToString("##############0.##"):string.Empty%>'></asp:TextBox>
                                                        <asp:RangeValidator ID="valRangeActExpense" ValidationGroup="MonthlyExpenses" runat="server"
                                                            ControlToValidate="txtActExpense" Type="Double" MinimumValue="0.00" MaximumValue="1000000000"
                                                            ErrorMessage="Actual Amount should be positive real" Text="*" />
                                                    </td>
                                                    <td>
                                                        <%# ((Decimal)Eval("Variance")).ToString("###,###,###,###,##0.##")%>
                                                    </td>
                                                </tr>
                                            </AlternatingItemTemplate>
                                            <FooterTemplate>
                                                </tbody></table></div>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:ValidationSummary ID="vsMonthlyExpense" ValidationGroup="MonthlyExpenses"
                                        runat="server" />
                                    <asp:CustomValidator ID="cvEstimatedSum" runat="server"
                                        ErrorMessage="The sum of monthly Estimated expenses should be equal to Expense Estimated amount"
                                        ToolTip="The sum of monthly Estimated expenses should be equal to Expense Estimated amount" Text="*"
                                        EnableClientScript="false" SetFocusOnError="true"></asp:CustomValidator>
                                    <asp:CustomValidator ID="cvActualSum" runat="server"
                                        ErrorMessage="The sum of monthly Actual expenses should be equal to Expense Actual amount"
                                        ToolTip="The sum of monthly Actual expenses should be equal to Expense Actual amount" Text="*"
                                        EnableClientScript="false" SetFocusOnError="true"></asp:CustomValidator>
                                    <asp:Label ID="lblEstiamatedError" runat="server" ForeColor="Red" Visible="false" Text="The sum of monthly Estimated expenses should be equal to Expense Estimated amount"></asp:Label>
                                    </br>
                                <asp:Label ID="lblActualError" runat="server" ForeColor="Red" Visible="false" Text="The sum of monthly Actual expenses should be equal to Expense Actual amount"></asp:Label>
                                </td>
                            </tr>
                            <tr class="bgColor_F5FAFF" style="text-align: center">
                                <td colspan="2">
                                    <asp:Button ID="btnCancelMonthlyExpense" Text="Cancel" ToolTip="Cancel" runat="server" />
                                    <asp:Button ID="btnSave" Text="Save" ToolTip="Save" runat="server" OnClick="btnSave_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>


