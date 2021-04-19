Class Educational.Subject Extends (%Library.Persistent, %Populate)
{

Relationship teacher As Educational.Teacher [ Cardinality = one, Inverse = subjects ];

Property name As %Library.String;

Storage Default
{
<Data name="SubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>teacher</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
</Data>
<DataLocation>^Educational.SubjectD</DataLocation>
<DefaultData>SubjectDefaultData</DefaultData>
<IdLocation>^Educational.SubjectD</IdLocation>
<IndexLocation>^Educational.SubjectI</IndexLocation>
<StreamLocation>^Educational.SubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
