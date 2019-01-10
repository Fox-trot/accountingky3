﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик двойного щелчка мыши, нажатия клавиши Enter или гиперссылки в табличном документе формы отчета.
// См. "Расширение поля формы для поля табличного документа.Выбор" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета          - УправляемаяФорма - Форма отчета.
//   Элемент              - ПолеФормы        - Табличный документ.
//   Область              - ОбластьЯчеекТабличногоДокумента - Выбранное значение.
//   СтандартнаяОбработка - Булево - Признак выполнения стандартной обработки события.
//
Процедура ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.РезультатыПроверкиУчета" Тогда
		Возврат;
	КонецЕсли;
		
	Расшифровка = Область.Расшифровка;
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Расшифровка.Свойство("Назначение") Тогда
			Если Расшифровка.Назначение = "ИсправитьПроблемы" Тогда
				ИсправитьПроблему(ФормаОтчета, Расшифровка);
			ИначеЕсли Расшифровка.Назначение = "ОткрытьФормуСписка" Тогда
				ОткрытьПроблемныйСписок(ФормаОтчета, Расшифровка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

// Открывает форму отчета с отбором по проблемам, препятствующим нормальному обновлению
// информационной базы.
//
//  Параметры:
//     Форма                - УправляемаяФорма - Управляемая форма проблемного объекта.
//     СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения
//                            стандартной (системной) обработки события.
//
// Пример:
//    МодульКонтрольВеденияУчетаСлужебныйКлиент.ОткрытьОтчетПоПроблемамИзОбработкиОбновления(ЭтотОбъект, СтандартнаяОбработка);
//
Процедура ОткрытьОтчетПоПроблемамИзОбработкиОбновления(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОтчетПоПроблемам("СистемныеПроверки");
	
КонецПроцедуры

// см. КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемам.
Процедура ОткрытьОтчетПоПроблемам(ВидПроверок) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидПроверки", ВидПроверок);
	
	ОткрытьФорму("Отчет.РезультатыПроверкиУчета.Форма", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму для интерактивных действий пользователя для решения проблемы.
//
// Параметры:
//   Форма       - УправляемаяФорма - форма отчета РезультатыПроверкиУчета.
//   Расшифровка - Структура - дополнительные сведения для исправления проблемы:
//      * Назначение                     - Строка - Строковый идентификатор назначения расшифровки.
//      * ИдентификаторПроверки          - Строка - Строковый индикатор проверки.
//      * ОбработчикПереходаКИсправлению - Строка - Имя экспортной клиентской процедуры-обработчика исправления 
//                                                   проблемы или полное имя открываемой формы.
//      * ВидПроверки                    - СправочникСсылка.ВидыПроверок - вид проверки,
//                                         дополнительно уточняющий область исправления проблемы.
//
Процедура ИсправитьПроблему(Форма, Расшифровка)
	
	ПараметрыИсправления = Новый Структура;
	ПараметрыИсправления.Вставить("ИдентификаторПроверки", Расшифровка.ИдентификаторПроверки);
	ПараметрыИсправления.Вставить("ВидПроверки",           Расшифровка.ВидПроверки);
	
	ОбработчикПереходаКИсправлению = Расшифровка.ОбработчикПереходаКИсправлению;
	Если СтрНачинаетсяС(ОбработчикПереходаКИсправлению, "ОбщаяФорма.") Или СтрНайти(ОбработчикПереходаКИсправлению, ".Форма") > 0 Тогда
		ОткрытьФорму(ОбработчикПереходаКИсправлению, ПараметрыИсправления, Форма);
	Иначе
		ОбработчикИсправления = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбработчикПереходаКИсправлению, ".");
		
		МодульОбработчикаИсправления  = ОбщегоНазначенияКлиент.ОбщийМодуль(ОбработчикИсправления[0]);
		ИмяПроцедуры = ОбработчикИсправления[1];
		
		ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения(ИмяПроцедуры, МодульОбработчикаИсправления), ПараметрыИсправления);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму списка (в случае регистра - с проблемным набором записей).
//
// Параметры:
//   Форма                          - УправляемаяФорма - Форма отчета.
//   Расшифровка - Структура - Структура, содержащая данные по исправлению проблемы
//                 расшифровки ячейки отчета по результатам проверок учета.
//      * Назначение         - Строка - Строковый идентификатор назначения расшифровки.
//      * ПолноеИмяОбъекта   - Строка - Полное имя объекта метаданных.
//      * Отбор              - Структура - Отбор в форме списка.
//
Процедура ОткрытьПроблемныйСписок(Форма, Расшифровка)
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ОтборКомпоновки           = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	
	ФормаРегистра = ПолучитьФорму(Расшифровка.ПолноеИмяОбъекта + ".ФормаСписка", , Форма);
	
	Для Каждого ЭлементОтбораНабора Из Расшифровка.Отбор Цикл
		
		ЭлементОтбора                = ОтборКомпоновки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЭлементОтбораНабора.Ключ);
		ЭлементОтбора.ПравоеЗначение = ЭлементОтбораНабора.Значение;
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Поле",          ЭлементОтбораНабора.Ключ);
		ПараметрыОтбора.Вставить("Значение",      ЭлементОтбораНабора.Значение);
		ПараметрыОтбора.Вставить("ВидСравнения",  ВидСравненияКомпоновкиДанных.Равно);
		ПараметрыОтбора.Вставить("Использование", Истина);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Истина);
		ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
		
		ДобавитьОтбор(ФормаРегистра.Список.КомпоновщикНастроек, ПараметрыОтбора, ДополнительныеПараметры);
		
	КонецЦикла;
	
	ФормаРегистра.Открыть();
	
КонецПроцедуры

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//   ЭлементСтруктуры        - КомпоновщикНастроекКомпоновкиДанных, НастройкиКомпоновкиДанных - элемент структуры КД
//   ПараметрыОтбора         - Структура - Содержит параметры отбора компоновки данных.
//     * Поле                - Строка - Имя поля, по которому добавляется отбор.
//     * Значение            - Произвольный - Значение отбора КД (по умолчанию: Неопределено).
//     * ВидСравнения        - ВидСравненияКомпоновкиДанных - Вид сравнений КД (по умолчанию: Неопределено).
//     * Использование       - Булево - Признак использования отбора (по умолчанию: Истина).
//   ДополнительныеПараметры - Структура - Содержит дополнительные параметры, перечисленные ниже:
//     * ВПользовательскиеНастройки - Булево - признак добавления в пользовательские настройки КД (по умолчанию: Ложь).
//     * ЗаменятьСуществующий       - Булево - признак полной замены существующего отбора по полю (по умолчанию: Истина).
//
// Возвращаемое значение:
//   ЭлементОтбораКомпоновкиДанных - Добавленный отбор.
//
Функция ДобавитьОтбор(ЭлементСтруктуры, ПараметрыОтбора, ДополнительныеПараметры = Неопределено)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
	Иначе
		Если Не ДополнительныеПараметры.Свойство("ВПользовательскиеНастройки") Тогда
			ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		КонецЕсли;
		Если Не ДополнительныеПараметры.Свойство("ЗаменятьСуществующий") Тогда
			ДополнительныеПараметры.Вставить("ЗаменятьСуществующий", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыОтбора.Поле) = Тип("Строка") Тогда
		НовоеПоле = Новый ПолеКомпоновкиДанных(ПараметрыОтбора.Поле);
	Иначе
		НовоеПоле = ПараметрыОтбора.Поле;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ДополнительныеПараметры.ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки =
					ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	Если ДополнительныеПараметры.ЗаменятьСуществующий Тогда
		Для каждого Элемент Из Отбор.Элементы Цикл
	
			Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
	
			Если Элемент.ЛевоеЗначение = НовоеПоле Тогда
				ЭлементОтбора = Элемент;
			КонецЕсли;
	
		КонецЦикла;
	КонецЕсли;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	ЭлементОтбора.Использование  = ПараметрыОтбора.Использование;
	ЭлементОтбора.ЛевоеЗначение  = НовоеПоле;
	ЭлементОтбора.ВидСравнения   = ?(ПараметрыОтбора.ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно,
		ПараметрыОтбора.ВидСравнения);
	ЭлементОтбора.ПравоеЗначение = ПараметрыОтбора.Значение;
	
	Возврат ЭлементОтбора;
	
КонецФункции

#КонецОбласти