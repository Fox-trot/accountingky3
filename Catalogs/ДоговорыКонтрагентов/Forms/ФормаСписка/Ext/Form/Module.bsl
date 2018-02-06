﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат; // Возврат при получении формы для анализа.
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Владелец", КонтрагентВладелец);
	
	Если ЗначениеЗаполнено(КонтрагентВладелец) Тогда
		// Контекстное открытие формы с отбором по контрагенту.
	
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru='Договоры с'") + " """ + КонтрагентВладелец + """";
		
	Иначе
		// Открытие в общем режиме.
		Элементы.Владелец.Видимость = Истина;		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.БанковскиеСчета);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Контрагент" Тогда	
		Элементы.Список.Обновить();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	НастроитьКомандуИспользоватьОсновным(ТекущиеДанные);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновной(Команда)
	
	ТекущиеДанные = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ИспользоватьКакОсновной.Пометка Тогда
		НеИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	Иначе
		ИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
	// Обновление данных после установки основного договора.
	ТекущиеДанные = ОбщегоНазначенияБПКлиент.ТекущиеДанныеДинамическогоСписка(Элементы.Список);
	НастроитьКомандуИспользоватьОсновным(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ИспользоватьКакОсновнойДоговор(Знач Договор)
	
	Справочники.ДоговорыКонтрагентов.УстановитьОсновнойДоговорКонтрагента(Договор);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НеИспользоватьКакОсновнойДоговор(Знач Договор)

	СтруктураПараметров = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Организация, ВидДоговора, Владелец");
	МенеджерЗаписи = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = СтруктураПараметров.Организация;
	МенеджерЗаписи.ВидДоговора = СтруктураПараметров.ВидДоговора;
	МенеджерЗаписи.Контрагент  = СтруктураПараметров.Владелец;
	МенеджерЗаписи.Договор     = Договор;
	МенеджерЗаписи.Удалить();

КонецПроцедуры

&НаКлиенте
Процедура НастроитьКомандуИспользоватьОсновным(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.ИспользоватьКакОсновной.Пометка     = Ложь;
		Элементы.ИспользоватьКакОсновной.Доступность = Ложь;
	Иначе
		Элементы.ИспользоватьКакОсновной.Пометка     = ТекущиеДанные.ЭтоОсновнойДоговор;
		Элементы.ИспользоватьКакОсновной.Доступность = Истина;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти