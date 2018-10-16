﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Физического лица

Процедура ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	СотрудникиФормыВнутренний.ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		ОбновитьОтображениеЛичныхДанных(Форма);
	КонецЕсли;
КонецПроцедуры

Процедура ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	СотрудникиФормыВнутренний.ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект);
	ОбновитьОтображениеЛичныхДанных(Форма);
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
    // СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(Форма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// Для нового физического лица устанавливаем ссылку
	Если Форма.Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(Форма.ФизическоеЛицоСсылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	СотрудникиФормыВнутренний.ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	СотрудникиФормыВнутренний.ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

//Процедура ФизическиеЛицаОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
//	ФизическоеЛицоОбъект = Форма.РеквизитФормыВЗначение("ФизЛицо");
//КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры

Процедура ОбновитьОтображениеЛичныхДанных(Форма)
	Форма.ФизическоеЛицоМестоРождения = ОбщегоНазначенияБПКлиентСервер.ПредставлениеМестаРождения(Форма.ФизЛицо.МестоРождения);
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
КонецПроцедуры

Процедура ЗаписатьЗначенияПоУмолчанию(ФизическоеЛицоСсылка, ГражданствоПоУмолчанию) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Если ГражданствоПоУмолчанию Тогда
		НаборЗаписей = РегистрыСведений.ГражданствоФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизЛицо.Установить(ФизическоеЛицоСсылка);
		Запись = НаборЗаписей.Добавить();
		Запись.ФизЛицо = ФизическоеЛицоСсылка;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		НаборЗаписей.Записать();
	КонецЕсли; 
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция ЗаблокироватьФизическоеЛицоПриРедактированииНаСервере(ФизическоеЛицоСсылка, ФизическоеЛицоВерсияДанных, ФормаУникальныйИдентификатор) Экспорт
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФизическоеЛицоСсылка, ФизическоеЛицоВерсияДанных, ФормаУникальныйИдентификатор);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ЛИЧНЫМИ ДАННЫМИ ФИЗ ЛИЦА

Процедура ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация = Неопределено) Экспорт
	СотрудникиФормыВнутренний.ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация);
КонецПроцедуры	

Функция ПроверитьНаличиеБанковскогоИлиКартСчета(ФизЛицо) Экспорт

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КартСчетаСотрудников.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КартСчетаСотрудников КАК КартСчетаСотрудников
		|ГДЕ
		|	КартСчетаСотрудников.Владелец = &ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Владелец = &ФизЛицо";
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаКартСчетов 		= МассивРезультатов[0].Выбрать();
	ВыборкаБанковскихСчетов = МассивРезультатов[1].Выбрать();	
	
	Если ВыборкаКартСчетов.Следующий() Тогда
		Структура = Новый Структура();
		Структура.Вставить("КартСчет", ВыборкаКартСчетов.Ссылка);
		Возврат Структура;
		
	ИначеЕсли ВыборкаБанковскихСчетов.Следующий() Тогда
		Структура = Новый Структура();
		Структура.Вставить("БанковскийСчет", ВыборкаБанковскихСчетов.Ссылка);
		Возврат Структура;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции // ПроверитьНаличиеБанковскогоИлиКартСчета()

////////////////////////////////////////////////////////////////////////////////
// Процедуры чтения / записи данных ФизическогоЛица

Процедура ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Организация = Неопределено, ИзФормыСотрудника = Ложь) Экспорт
	СотрудникиФормыВнутренний.ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Организация, ИзФормыСотрудника);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

Процедура ПрочитатьДанныеИзХранилищаВФорму(Форма, ОписаниеДополнительнойФормы, АдресВХранилище) Экспорт
	РедактируемыеДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Для каждого ДанныеФормы Из РедактируемыеДанные.ДополнительныеДанные Цикл
		
		Если ТипЗнч(ДанныеФормы.Значение) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(Форма[ДанныеФормы.Ключ], ДанныеФормы.Значение);
		ИначеЕсли ТипЗнч(ДанныеФормы.Значение) = Тип("Массив") Тогда
			Форма[ДанныеФормы.Ключ].Очистить();
			Для каждого ЗаписьДанных Из ДанныеФормы.Значение Цикл
				НоваяЗапись = Форма[ДанныеФормы.Ключ].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьДанных);
			КонецЦикла;
		Иначе
			Форма[ДанныеФормы.Ключ] = ДанныеФормы.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого ДанныеФормы Из РедактируемыеДанные.РеквизитыОбъекта Цикл
		
		ПутьКДанным = "";
		Если ОписаниеДополнительнойФормы.РеквизитыОбъекта.Свойство(ДанныеФормы.Ключ, ПутьКДанным) Тогда
			
			Если ТипЗнч(ДанныеФормы.Значение) = Тип("Массив") Тогда
				
				Данные = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДанным);
				Данные.Очистить();
				Для каждого ЗаписьДанных Из ДанныеФормы.Значение Цикл
					НоваяЗапись = Данные.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьДанных);
				КонецЦикла;
				
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ПутьКДанным, ДанныеФормы.Значение);
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

Функция АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, Форма) Экспорт
	
	ПомещаемыеДанные = Новый Структура;
	ПомещаемыеДанные.Вставить("ДополнительныеДанные", Новый Структура);
	ПомещаемыеДанные.Вставить("РеквизитыОбъекта", Новый Структура);
	
	Для каждого РедактируемыйРеквизит Из ОписаниеДополнительнойФормы.ДополнительныеДанные Цикл
		
		Если ТипЗнч(Форма[РедактируемыйРеквизит.Ключ]) = Тип("ДанныеФормыСтруктура") Тогда
			
			ПомещаемоеЗначение = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
				Форма[РедактируемыйРеквизит.Ключ], Метаданные.РегистрыСведений[РедактируемыйРеквизит.Ключ]);
			
		ИначеЕсли ТипЗнч(Форма[РедактируемыйРеквизит.Ключ]) = Тип("ДанныеФормыСтруктураСКоллекцией") Тогда
			
			Таблица = Форма[РедактируемыйРеквизит.Ключ].Выгрузить();
			ПомещаемоеЗначение = ОбщегоНазначения.ТаблицаЗначенийВМассив(Таблица);
			
		Иначе
			ПомещаемоеЗначение = Форма[РедактируемыйРеквизит.Ключ];
		КонецЕсли;
		
		ПомещаемыеДанные.ДополнительныеДанные.Вставить(РедактируемыйРеквизит.Ключ, ПомещаемоеЗначение);
		
	КонецЦикла;
	
	Для каждого РедактируемыйРеквизит Из ОписаниеДополнительнойФормы.РеквизитыОбъекта Цикл
		
		Данные = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, РедактируемыйРеквизит.Значение);
		Если ТипЗнч(Данные) = Тип("ДанныеФормыКоллекция") Тогда
			РедактируемыеДанные = ОбщегоНазначения.ТаблицаЗначенийВМассив(Данные.Выгрузить());
		Иначе
			РедактируемыеДанные = Данные;
		КонецЕсли;
		
		ПомещаемыеДанные.РеквизитыОбъекта.Вставить(РедактируемыйРеквизит.Ключ, РедактируемыеДанные);
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ПомещаемыеДанные, Форма.УникальныйИдентификатор);
	
КонецФункции

// Функция - Проверить возможность внесения кадровых изменений
//
// Параметры:
//  ДокументСсылка	 - Ссылка - ссылка на документ
//  Организация		 - СправочникСсылка.Организации	 - Организация для отбора 
//  ФизЛицо			 - СправочникСсылка.ФизическиеЛица	 - ФизЛицо для отбора 
//  ДатаИзменений	 - Дата	 - 
// 
// Возвращаемое значение:
//  РезультатПроверки - структура
//
Функция ПроверитьВозможностьВнесенияКадровыхИзменений(ДокументСсылка, Организация, ФизЛицо, ДатаИзменений = '00010101') Экспорт 
	РезультатПроверки = Новый Структура("ИзмененияВозможны,РегистраторПредставление,Регистратор, Подразделение, Должность,ДатаИзменений", Истина, "");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПервых.Организация,
		|	СотрудникиСрезПервых.ФизЛицо,
		|	СотрудникиСрезПервых.Подразделение,
		|	СотрудникиСрезПервых.Должность,
		|	СотрудникиСрезПервых.Период КАК ДатаИзменений,
		|	СотрудникиСрезПервых.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СотрудникиСрезПервых.Регистратор) КАК РегистраторПредставление
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПервых(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И Регистратор <> &Ссылка) КАК СотрудникиСрезПервых
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеНачисленияСрезПервых.Организация,
		|	ПлановыеНачисленияСрезПервых.ФизЛицо,
		|	ПлановыеНачисленияСрезПервых.Подразделение,
		|	ПлановыеНачисленияСрезПервых.Должность,
		|	ПлановыеНачисленияСрезПервых.Период,
		|	ПлановыеНачисленияСрезПервых.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПлановыеНачисленияСрезПервых.Регистратор)
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияНачало.СрезПервых(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И Регистратор <> &Ссылка) КАК ПлановыеНачисленияСрезПервых
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеНачисленияСрезПервых.Организация,
		|	ПлановыеНачисленияСрезПервых.ФизЛицо,
		|	NULL,
		|	NULL,
		|	ПлановыеНачисленияСрезПервых.Период,
		|	ПлановыеНачисленияСрезПервых.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПлановыеНачисленияСрезПервых.Регистратор)
		|ИЗ
		|	РегистрСведений.ПлановыеНачисленияОкончание.СрезПервых(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И Регистратор <> &Ссылка) КАК ПлановыеНачисленияСрезПервых
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержанияСрезПервых.Организация,
		|	ПлановыеУдержанияСрезПервых.ФизЛицо,
		|	NULL,
		|	NULL,
		|	ПлановыеУдержанияСрезПервых.Период,
		|	ПлановыеУдержанияСрезПервых.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПлановыеУдержанияСрезПервых.Регистратор)
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияНачало.СрезПервых(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И Регистратор <> &Ссылка) КАК ПлановыеУдержанияСрезПервых
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержанияСрезПервых.Организация,
		|	ПлановыеУдержанияСрезПервых.ФизЛицо,
		|	NULL,
		|	NULL,
		|	ПлановыеУдержанияСрезПервых.Период,
		|	ПлановыеУдержанияСрезПервых.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПлановыеУдержанияСрезПервых.Регистратор)
		|ИЗ
		|	РегистрСведений.ПлановыеУдержанияОкончание.СрезПервых(
		|			&Период,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И Регистратор <> &Ссылка) КАК ПлановыеУдержанияСрезПервых";
	Запрос.УстановитьПараметр("Период", ДатаИзменений);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(РезультатПроверки, Выборка);
		
		РезультатПроверки.ИзмененияВозможны = Ложь;
	КонецЕсли; 
	
	Возврат РезультатПроверки;

КонецФункции // ПроверитьВозможностьВнесенияКадровыхИзменений()
