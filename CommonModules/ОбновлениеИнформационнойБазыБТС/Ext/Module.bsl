﻿////////////////////////////////////////////////////////////////////////////////
// ОбновлениеИнформационнойБазыБТС: Библиотека технологии сервиса (БТС).
// Процедуры и функции БТС.
//
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаТехнологииСервиса";
	Описание.Версия = ТехнологияСервиса.ВерсияБиблиотеки();
	
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
	Описание.ИдентификаторИнтернетПоддержки = "SMTL";
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.0.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//  Обработчик.Опциональный        = Истина;
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей 
//                                  см. в процедуре ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Обязательные подсистемы
	ТехнологияСервиса.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	
	// Опциональные подсистемы
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		МодульВыгрузкаЗагрузкаДанныхСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ВыгрузкаЗагрузкаДанныхСлужебный");
		МодульВыгрузкаЗагрузкаДанныхСлужебный.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		МодульИнформационныйЦентрСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ИнформационныйЦентрСлужебный");
		МодульИнформационныйЦентрСлужебный.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ЦентрКонтроляКачества") Тогда
		МодульИнцидентыЦККСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ИнцидентыЦККСлужебный");
		МодульИнцидентыЦККСлужебный.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	
	РаботаВМоделиСервисаБТС.ПриДобавленииОбработчиковОбновления(Обработчики);
	ИнтеграцияПодсистемБТС.ПриДобавленииОбработчиковОбновленияБТС(Обработчики);
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.РасширенияВМоделиСервиса") Тогда
		МодульРасширенияВМоделиСервиса = ИнтеграцияПодсистемБТС.ОбщийМодуль("РасширенияВМоделиСервиса");
		МодульРасширенияВМоделиСервиса.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.УправлениеТарифами") Тогда
		МодульТарификацияСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ТарификацияСлужебный");
		МодульТарификацияСлужебный.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданийВнешнийИнтерфейс") Тогда
		МодульОчередьЗаданийВнешнийИнтерфейс = ИнтеграцияПодсистемБТС.ОбщийМодуль("ОчередьЗаданийВнешнийИнтерфейс");
		МодульОчередьЗаданийВнешнийИнтерфейс.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ИнтеграцияПодсистемБТС.ОбщийМодуль("МиграцияПриложений");
		МодульМиграцияПриложений.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
// Параметры:
//   ПредыдущаяВерсия - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//		сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//		то будет выдана форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
		
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
		
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	РежимОбновленияДанных = "ОбновлениеВерсии";
	
КонецПроцедуры 

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
