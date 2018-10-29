﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтоАдресВременногоХранилища(Параметры.Результат) Тогда
		Результат.Вывести(ПолучитьИзВременногоХранилища(Параметры.Результат));
	КонецЕсли; 
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПриОткрытииЗадержка", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗадержка()
	
	Элементы.Результат.ЦветРамки = WebЦвета.Белый;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

