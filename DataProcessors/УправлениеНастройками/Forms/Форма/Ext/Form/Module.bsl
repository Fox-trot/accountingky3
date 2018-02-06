﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказыватьПриОткрытииПрограммы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеНастройками", "Показывать", Истина);
	
	Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	РеквизитыОрганизации = Организация;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Организации" Тогда
		ЭтаФорма.ОбновитьОтображениеДанных();	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	РеквизитыОрганизации = Организация;
	
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода ПоказыватьПриОткрытииПрограммы
//
&НаКлиенте
Процедура ПоказыватьПриОткрытииПрограммыПриИзменении(Элемент)
	СохранитьНастройкиПоказыватьПриОткрытииПрограммы(ПоказыватьПриОткрытииПрограммы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БанковскийСчетОрганизации(Команда)
	ПараметрыФормы = Новый Структура("Владелец", Организация);
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

&НаКлиенте
Процедура КассыОрганизации(Команда)
	ПараметрыФормы = Новый Структура("Владелец", Организация);
	ОткрытьФорму("Справочник.Кассы.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяПолитикаОрганизации(Команда)
	ПараметрыФормы = Новый Структура("Организация", Организация);
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаОрганизаций.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяПолитикаПоПерсоналу(Команда)
	ПараметрыФормы = Новый Структура("Организация", Организация);
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаПоПерсоналу.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

&НаКлиенте
Процедура Подразделения(Команда)
	ПараметрыФормы = Новый Структура("Владелец", Организация);
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныеЛицаОрганизации(Команда)
	ПараметрыФормы = Новый Структура("Организация", Организация);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаСписка", Новый Структура("Отбор", ПараметрыФормы));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура сохранения настройки показа обработки "УправлениеНастройками".
//
&НаСервереБезКонтекста
Процедура СохранитьНастройкиПоказыватьПриОткрытииПрограммы(ПоказыватьПриОткрытииПрограммы)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("УправлениеНастройками", "Показывать", ПоказыватьПриОткрытииПрограммы);
	
КонецПроцедуры

#КонецОбласти
