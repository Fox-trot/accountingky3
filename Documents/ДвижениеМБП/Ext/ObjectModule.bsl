﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ДвижениеМБП.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ВидУчетаИзносаМБП = ДополнительныеСвойства.УчетнаяПолитика.ВидУчетаИзносаМБП;
		
	Если ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию Тогда
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства, Движения, Отказ, Истина);
		Иначе
			УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства, Движения, Отказ);
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБП Тогда
		УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства, Движения, Отказ);
		
	Иначе
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриСписании Тогда
			УчетМБП.СформироватьДвиженияСписаниеМБПВЭксплуатации(ДополнительныеСвойства, Движения, Отказ, Истина);
		Иначе
			УчетМБП.СформироватьДвиженияСписаниеМБПВЭксплуатации(ДополнительныеСвойства, Движения, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВидУчетаИзносаМБП = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация).ВидУчетаИзносаМБП;
	
	Если Товары.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Закладка ""МБП"" должна быть заполнена!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);	
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию Тогда  
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриСписании Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБП Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.СписаниеМБП Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицоПолучатель");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.РеализацияМБП Тогда  
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицоПолучатель");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|					) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	Не СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
	
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицоПолучатель);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		ВыборкаИзРезультатаЗапроса = Результат.Выбрать();
		ВыборкаИзРезультатаЗапроса.Следующий();

		ТекстСообщения = СтрШаблон(НСтр("ru = 'По текущему сотруднику %1 не оформлен прием на работу.'"), 
		ФизЛицоПолучатель);
		БухгалтерскийУчетСервер.СообщитьОбОшибке(
		ЭтотОбъект,
		ТекстСообщения,
		,
		,
		"ФизЛицоПолучатель",
		Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли