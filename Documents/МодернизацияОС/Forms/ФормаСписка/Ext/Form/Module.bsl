﻿#Область ОбработчикиСобытийФормы
	
// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// БП.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	УстановитьОтборПоОсновнойОрганизации();
	// Конец БП.ОтборыСписка
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.МодернизацияОС);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		// БП.ОтборыСписка
		СохранитьНастройкиОтборов();
		// Конец БП.ОтборыСписка
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовОтборов
	
&НаКлиенте
Процедура ОтборОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ОсновноеСредство", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПараметрОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ПараметрыОС.Параметр", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСобытиеОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СобытиеОС", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьОтборПоОсновнойОрганизации()

	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		ОсновнаяОрганизация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда 
			УстановитьМеткуИОтборСписка("Организация", Элементы.ОтборОрганизация.Родитель.Имя, ОсновнаяОрганизация);
		КонецЕсли;	
	Иначе
		УдаляемыеМетки = Новый СписокЗначений;
		Для Каждого Элемент Из Элементы.ОтборОрганизация.Родитель.ПодчиненныеЭлементы Цикл 
			Если СтрНайти(Элемент.Имя, "Метка_") > 0 Тогда 
				МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
				УдалитьМеткуОтбора(МеткаИД);
			КонецЕсли;	
		КонецЦикла;	
		
		УдалитьМеткиОтбора(УдаляемыеМетки);
		ОбновитьЭлементыМеток();
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения = "" Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборыНажатие(Элемент)
	
	МеткаИД = 0;
	УдаляемыеМетки = Новый СписокЗначений;
	Для каждого Метка Из ДанныеМеток Цикл
		
		УдаляемыеМетки.Добавить(МеткаИД);
		МеткаИД = МеткаИД + 1;
	КонецЦикла;
	
	УдалитьМеткиОтбора(УдаляемыеМетки);
	
	ОбновитьЭлементыМеток();
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткиОтбора(Метки)
	
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список, Метки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыМеток()
	
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти