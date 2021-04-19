Class Educational.Meeting Extends (%Library.Persistent, %Library.Populate)
{

Relationship teacher As Educational.Teacher [ Cardinality = one, Inverse = appointments ];

Relationship student As Educational.Student [ Cardinality = one, Inverse = appointments ];

Property date As %PosixTime;

Storage Default
{
<Data name="MeetingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>teacher</Value>
</Value>
<Value name="3">
<Value>student</Value>
</Value>
<Value name="4">
<Value>date</Value>
</Value>
</Data>
<DataLocation>^Educational.MeetingD</DataLocation>
<DefaultData>MeetingDefaultData</DefaultData>
<IdLocation>^Educational.MeetingD</IdLocation>
<IndexLocation>^Educational.MeetingI</IndexLocation>
<StreamLocation>^Educational.MeetingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
