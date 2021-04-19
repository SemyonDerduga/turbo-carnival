Class Educational.Subject Extends (%Library.Persistent, %Populate)
{

Relationship meetings As Educational.Meeting [ Cardinality = many, Inverse = subject ];

Property subjectName As %Library.String;

Index subjectNameKey On subjectName [ Unique ];

Storage Default
{
<Data name="SubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>subjectName</Value>
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
