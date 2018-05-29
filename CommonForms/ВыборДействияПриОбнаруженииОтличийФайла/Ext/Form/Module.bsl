﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		Параметры,
		"ДатаИзмененияВРабочемКаталоге,
		|ДатаИзмененияВХранилищеФайлов,
		|ПолноеИмяФайлаВРабочемКаталоге,
		|РазмерВРабочемКаталоге,
		|РазмерВХранилищеФайлов,
		|Сообщение,
		|Заголовок");
		
	ТестНовее = " (" + НСтр("ru='новее'") + ")";
	Если ДатаИзмененияВРабочемКаталоге > ДатаИзмененияВХранилищеФайлов Тогда
		ДатаИзмененияВРабочемКаталоге = Строка(ДатаИзмененияВРабочемКаталоге) + ТестНовее;
	Иначе
		ДатаИзмененияВХранилищеФайлов = Строка(ДатаИзмененияВХранилищеФайлов) + ТестНовее;
	КонецЕсли;
	
	Элементы.Сообщение.Высота = СтрЧислоСтрок(Сообщение) + 2;
	
	Если Параметры.ДействиеНадФайлом = "ПомещениеВХранилищеФайлов" Тогда
		
		Элементы.ФормаОткрытьСуществующий.Видимость = Ложь;
		Элементы.ФормаВзятьИзХранилища.Видимость    = Ложь;
		Элементы.ФормаПоместить.КнопкаПоУмолчанию   = Истина;
		
	ИначеЕсли Параметры.ДействиеНадФайлом = "ОткрытиеВРабочемКаталоге" Тогда
		
		Элементы.ФормаПоместить.Видимость  = Ложь;
		Элементы.ФормаНеПомещать.Видимость = Ложь;
		Элементы.ФормаОткрытьСуществующий.КнопкаПоУмолчанию = Истина;
	Иначе
		ВызватьИсключение НСтр("ru = 'Неизвестное действие над файлом'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСуществующий(Команда)
	
	Закрыть("ОткрытьСуществующий");
	
КонецПроцедуры

&НаКлиенте
Процедура Поместить(Команда)
	
	Закрыть("ПОМЕСТИТЬ");
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьИзПрограммы(Команда)
	
	Закрыть("ВзятьИзХранилищаИОткрыть");
	
КонецПроцедуры

&НаКлиенте
Процедура НеПомещать(Команда)
	
	Закрыть("НеПомещать");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталог(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьПроводникСФайлом(ПолноеИмяФайлаВРабочемКаталоге);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть("Отменить");
	
КонецПроцедуры

#КонецОбласти
