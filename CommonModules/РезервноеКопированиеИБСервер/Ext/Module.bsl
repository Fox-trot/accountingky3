﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает начальное заполнение настроек автоматического резервного копирования.
//
// Параметры:
//	СохранятьПараметры - сохранять или нет параметры в хранилище настроек.
//
// Возвращаемое значение - Структура - начальное заполнение параметров резервного копирования.
//
Функция НачальноеЗаполнениеНастроекРезервногоКопирования(СохранятьПараметры = Истина) Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("ВыполнятьАвтоматическоеРезервноеКопирование", Ложь);
	Параметры.Вставить("РезервноеКопированиеНастроено", Ложь);
	
	Параметры.Вставить("ДатаПоследнегоОповещения", '00010101');
	Параметры.Вставить("ДатаПоследнегоРезервногоКопирования", '00010101');
	Параметры.Вставить("МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования", '29990101');
	
	Параметры.Вставить("РасписаниеКопирования", ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Новый РасписаниеРегламентногоЗадания));
	Параметры.Вставить("КаталогХраненияРезервныхКопий", "");
	Параметры.Вставить("КаталогХраненияРезервныхКопийПриРучномЗапуске", ""); // При ручном выполнении
	Параметры.Вставить("ПроведеноКопирование", Ложь);
	Параметры.Вставить("ПроведеноВосстановление", Ложь);
	Параметры.Вставить("РезультатКопирования", Неопределено);
	Параметры.Вставить("ИмяФайлаРезервнойКопии", "");
	Параметры.Вставить("ВариантВыполнения", "ПоРасписанию");
	Параметры.Вставить("ПроцессВыполняется", Ложь);
	Параметры.Вставить("АдминистраторИБ", "");
	Параметры.Вставить("ПарольАдминистратораИБ", "");
	Параметры.Вставить("ПараметрыУдаления", ПараметрыУдаленияРезервныхКопийПоУмолчанию());
	Параметры.Вставить("РучнойЗапускПоследнегоРезервногоКопирования", Истина);
	
	Если СохранятьПараметры Тогда
		УстановитьПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Возвращает текущую настройку резервного копирования строкой.
// Два варианта использования функции - или с передачей всех параметров или без параметров.
//
Функция ТекущаяНастройкаРезервногоКопирования() Экспорт
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	Если НастройкиРезервногоКопирования = Неопределено Тогда
		Возврат НСтр("ru = 'Для настройки резервного копирования необходимо обратиться к администратору.'");
	КонецЕсли;
	
	ТекущаяНастройка = НСтр("ru = 'Резервное копирование не настроено, информационная база подвергается риску потери данных.'");
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Если НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
			
			Если НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно при завершении работы.'");
			ИначеЕсли НастройкиРезервногоКопирования.ВариантВыполнения = "ПоРасписанию" Тогда // По расписанию
				Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
				Если Не ПустаяСтрока(Расписание) Тогда
					ТекущаяНастройка = НСтр("ru = 'Резервное копирование выполняется регулярно по расписанию: %1'");
					ТекущаяНастройка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекущаяНастройка, Расписание);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если НастройкиРезервногоКопирования.РезервноеКопированиеНастроено Тогда
				ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано сторонними программами).'");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяНастройка = НСтр("ru = 'Резервное копирование не выполняется (организовано средствами СУБД).'");
		
	КонецЕсли;
	
	Возврат ТекущаяНастройка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент()
		Или ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	ОтключеноУведомлениеОНастройкеРезервногоКопирования = МодульТекущиеДелаСервер.ДелоОтключено("НастроитьРезервноеКопирование");
	ОтключеноУведомлениеОВыполненииРезервногоКопирования = МодульТекущиеДелаСервер.ДелоОтключено("ВыполнитьРезервноеКопирование");
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Обработки.НастройкаРезервногоКопированияИБ)
		Или (ОтключеноУведомлениеОНастройкеРезервногоКопирования
			И ОтключеноУведомлениеОВыполненииРезервногоКопирования) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	Если НастройкиРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантОповещения = НастройкиРезервногоКопирования.ПараметрОповещения;
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Обработки.НастройкаРезервногоКопированияИБ.ПолноеИмя());
	
	Для Каждого Раздел Из Разделы Цикл
		
		Если Не ОтключеноУведомлениеОНастройкеРезервногоКопирования Тогда
			
			ИмяФормыНастройкиРезервногоКопирования = ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(),
				"Обработка.НастройкаРезервногоКопированияИБ.Форма.НастройкаРезервногоКопирования",
				"Обработка.НастройкаРезервногоКопированияИБ.Форма.НастройкаРезервногоКопированияКлиентСервер");
			
			Дело = ТекущиеДела.Добавить();
			Дело.Идентификатор  = "НастроитьРезервноеКопирование" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
			Дело.ЕстьДела       = ВариантОповещения = "ЕщеНеНастроено";
			Дело.Представление  = НСтр("ru = 'Настроить резервное копирование'");
			Дело.Важное         = Истина;
			Дело.Форма          = ИмяФормыНастройкиРезервногоКопирования;
			Дело.Владелец       = Раздел;
		КонецЕсли;
		
		Если Не ОтключеноУведомлениеОВыполненииРезервногоКопирования Тогда
			Дело = ТекущиеДела.Добавить();
			Дело.Идентификатор  = "ВыполнитьРезервноеКопирование" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
			Дело.ЕстьДела       = ВариантОповещения = "Просрочено";
			Дело.Представление  = НСтр("ru = 'Резервное копирование не выполнено'");
			Дело.Важное         = Истина;
			Дело.Форма          = "Обработка.РезервноеКопированиеИБ.Форма.РезервноеКопированиеДанных";
			Дело.Владелец       = Раздел;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования(Истина));
	Параметры.Вставить("РезервноеКопированиеИБПриЗавершенииРаботы", ПараметрыПриЗавершенииРаботы());
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеИБ", НастройкиРезервногоКопирования());
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.15";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_1_15";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.33";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_1_33";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.2.33";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_2_33";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.4.36";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Процедура = "РезервноеКопированиеИБСервер.ОбновитьПараметрыРезервногоКопирования_2_2_4_36";
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриВключенииИспользованияПрофилейБезопасности.
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПарольАдминистратораИБ") Тогда
		
		ПараметрыРезервногоКопирования.ПарольАдминистратораИБ = "";
		УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает параметры подсистемы РезервногоКопированияИБ, которые необходимы при завершении работы
// пользователей.
//
// Возвращаемое значение:
//	Структура - параметры.
//
Функция ПараметрыПриЗавершенииРаботы()
	
	НастройкиРезервногоКопирования = НастройкиРезервногоКопирования();
	ВыполнятьПриЗавершенииРаботы = ?(НастройкиРезервногоКопирования = Неопределено, Ложь,
		НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование
		И НастройкиРезервногоКопирования.ВариантВыполнения = "ПриЗавершенииРаботы");
	
	ПараметрыПриЗавершении = Новый Структура;
	ПараметрыПриЗавершении.Вставить("ДоступностьРолейОповещения",   Пользователи.ЭтоПолноправныйПользователь(,Истина));
	ПараметрыПриЗавершении.Вставить("ВыполнятьПриЗавершенииРаботы", ВыполнятьПриЗавершенииРаботы);
	
	Возврат ПараметрыПриЗавершении;
	
КонецФункции

// Возвращает значение периода по заданному интервалу времени.
//
// Параметры:
//	ИнтервалВремени - Число - интервал времени в секундах.
//	
// Возвращаемое значение - Структура с полями:
//	ТипПериода - Строка - тип периода: День, Неделя, Месяц, Год.
//	ЗначениеПериода - Число - длина периода для заданного типа.
//
Функция ЗначениеПериодаПоИнтервалуВремени(ИнтервалВремени)
	
	ВозвращаемаяСтруктура = Новый Структура("ТипПериода, ЗначениеПериода", "Месяц", 1);
	
	Если ИнтервалВремени = Неопределено Тогда 
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;	
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 365)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Год";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 365);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 30)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Месяц";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 30);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24 * 7)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "Неделя";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24 * 7);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Если Цел(ИнтервалВремени / (3600 * 24)) > 0 Тогда 
		ВозвращаемаяСтруктура.ТипПериода		= "День";
		ВозвращаемаяСтруктура.ЗначениеПериода	= ИнтервалВремени / (3600 * 24);
		Возврат ВозвращаемаяСтруктура;
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Возвращает сохраненные параметры резервного копирования.
//
// Возвращаемое значение - Структура - параметры резервного копирования.
//
Функция ПараметрыРезервногоКопирования() Экспорт
	
	Параметры = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыРезервногоКопирования", "");
	Если Параметры = Неопределено Тогда
		Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования();
	Иначе
		ПривестиПараметрыРезервногоКопирования(Параметры);
	КонецЕсли;
	Возврат Параметры;
	
КонецФункции

// Приводит параметры резервного копирования.
// Если в текущих параметрах резервного копирования нет параметра, который есть в 
// функции "НачальноеЗаполнениеНастроекРезервногоКопирования", то он добавляется со значением по умолчанию.
//
// Параметры:
//	ПараметрыРезервногоКопирования - Структура - параметры резервного копирования ИБ.
//
Процедура ПривестиПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования)
	
	ПараметрыИзменены = Ложь;
	
	Параметры = НачальноеЗаполнениеНастроекРезервногоКопирования(Ложь);
	Для Каждого ЭлементСтруктуры Из Параметры Цикл
		НайденноеЗначение = Неопределено;
		Если ПараметрыРезервногоКопирования.Свойство(ЭлементСтруктуры.Ключ, НайденноеЗначение) Тогда
			Если НайденноеЗначение = Неопределено И ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		Иначе
			Если ЭлементСтруктуры.Значение <> Неопределено Тогда
				ПараметрыРезервногоКопирования.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
				ПараметрыИзменены = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПараметрыИзменены Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Сохраняет параметры резервного копирования.
//
// Параметры:
//	СтруктураПараметров - Структура - параметры резервного копирования.
//
Процедура УстановитьПараметрыРезервногоКопирования(СтруктураПараметров, ТекущийПользователь = Неопределено) Экспорт
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПараметрыРезервногоКопирования", "", СтруктураПараметров);
	Если ТекущийПользователь <> Неопределено Тогда
		ПараметрыКопирования = Новый Структура("Пользователь", ТекущийПользователь);
		Константы.ПараметрыРезервногоКопирования.Установить(Новый ХранилищеЗначения(ПараметрыКопирования));
	КонецЕсли;
КонецПроцедуры

// Проверяет, не настало ли время проводить автоматическое резервное копирование.
//
// Возвращаемое значение:
//   Булево - Истина, если настал момент проведения резервного копирования.
//
Функция НеобходимостьАвтоматическогоРезервногоКопирования()
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Параметры = ПараметрыРезервногоКопирования();
	Если Параметры = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Расписание = Параметры.РасписаниеКопирования;
	Если Расписание = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроцессВыполняется") И Параметры.ПроцессВыполняется Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаПроверки = ТекущаяДатаСеанса();
	ДатаСледующегоКопирования = Параметры.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	Если ДатаСледующегоКопирования = '29990101' Или ДатаСледующегоКопирования > ДатаПроверки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатаНачалаПроверки = Параметры.ДатаПоследнегоРезервногоКопирования;
	РасписаниеЗначение = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	Возврат РасписаниеЗначение.ТребуетсяВыполнение(ДатаПроверки, ДатаНачалаПроверки);
	
КонецФункции

// Возвращает значение настройки "Статус резервного копирования" в части результата.
// Используется при начале работы системы для показа формы с результатами резервного копирования.
//
Процедура УстановитьРезультатРезервногоКопирования() Экспорт
	
	СтруктураПараметров = НастройкиРезервногоКопирования();
	СтруктураПараметров.ПроведеноКопирование = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
	
КонецПроцедуры

// Устанавливает дату последнего оповещения пользователя.
//
// Параметры: 
//	ДатаНапоминания - Дата - дата и время последнего оповещения пользователя о необходимости проведения резервного
//	                         копирования.
//
Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	ПараметрыОповещений = ПараметрыРезервногоКопирования();
	ПараметрыОповещений.ДатаПоследнегоОповещения = ДатаНапоминания;
	УстановитьПараметрыРезервногоКопирования(ПараметрыОповещений);
	
КонецПроцедуры

// Устанавливает настройку в параметры резервного копирования. 
// 
// Параметры: 
//	ИмяЭлемента - Строка - имя параметра.
// 	ЗначениеЭлемента - Произвольный тип - значение параметра.
//
Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	
	СтруктураНастроек = ПараметрыРезервногоКопирования();
	СтруктураНастроек.Вставить(ИмяЭлемента, ЗначениеЭлемента);
	УстановитьПараметрыРезервногоКопирования(СтруктураНастроек);
	
КонецПроцедуры

// Возвращает структуру с параметрами резервного копирования.
// 
// Параметры: 
//	НачалоРаботы - Булево - признак вызова при начале работы программы.
//
// Возвращаемое значение:
//  Структура - параметры резервного копирования.
//
Функция НастройкиРезервногоКопирования(НачалоРаботы = Ложь) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено; // Не выполнен вход в область данных.
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(,Истина) Тогда
		Возврат Неопределено; // Текущий пользователь не обладает необходимыми правами.
	КонецЕсли;
	
	Результат = ПараметрыРезервногоКопирования();
	
	// Определение варианта оповещения пользователя.
	ВариантОповещения = "НеОповещать";
	ОповещатьОНеобходимостиРезервногоКопирования = ТекущаяДатаСеанса() >= (Результат.ДатаПоследнегоОповещения + 3600 * 24);
	Если Результат.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
		ВариантОповещения = ?(НеобходимостьАвтоматическогоРезервногоКопирования(), "Просрочено", "Настроено");
	ИначеЕсли Не Результат.РезервноеКопированиеНастроено Тогда
		Если ОповещатьОНеобходимостиРезервногоКопирования Тогда	
			НастройкиРезервногоКопирования = Константы.ПараметрыРезервногоКопирования.Получить().Получить();
			Если НастройкиРезервногоКопирования <> Неопределено
				И НастройкиРезервногоКопирования.Пользователь <> ПользователиКлиентСервер.ТекущийПользователь() Тогда
				ВариантОповещения = "НеОповещать";
			Иначе
				ВариантОповещения = "ЕщеНеНастроено";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Результат.Вставить("ПараметрОповещения", ВариантОповещения);
	
	Если Результат.ПроведеноКопирование И Результат.РезультатКопирования  Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Результат.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса;
		// Сохранение даты последнего резервного копирования в хранилище общих настроек.
		СтруктураПараметров = ПараметрыРезервногоКопирования();
		СтруктураПараметров.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса;
		УстановитьПараметрыРезервногоКопирования(СтруктураПараметров);
	КонецЕсли;
	
	Если Результат.ПроведеноВосстановление Тогда
		ОбновитьРезультатВосстановления();
	КонецЕсли;
	
	Если НачалоРаботы И Результат.ПроцессВыполняется Тогда
		Результат.ПроцессВыполняется = Ложь;
		УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обновляет результат восстановления и обновляет структуру параметров резервного копирования. 
//
Процедура ОбновитьРезультатВосстановления()
	
	СтруктураВозврата = ПараметрыРезервногоКопирования();
	СтруктураВозврата.ПроведеноВосстановление = Ложь;
	УстановитьПараметрыРезервногоКопирования(СтруктураВозврата);
	
КонецПроцедуры

// Возвращает информацию о текущем пользователе.
//
Функция ИнформацияОПользователе() Экспорт
	
	ИнформацияОПользователе = Новый Структура("Имя, ТребуетсяВводПароля", "", Ложь);
	ИспользуютсяПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0;
	
	Если Не ИспользуютсяПользователи Тогда
		Возврат ИнформацияОПользователе;
	КонецЕсли;
	
	ТекущийПользователь = СтандартныеПодсистемыСервер.ТекущийПользователь();
	ТребуетсяВводПароля = ТекущийПользователь.ПарольУстановлен И ТекущийПользователь.АутентификацияСтандартная;
	
	ИнформацияОПользователе.Имя = ТекущийПользователь.Имя;
	ИнформацияОПользователе.ТребуетсяВводПароля = ТребуетсяВводПароля;
	
	Возврат ИнформацияОПользователе;
	
КонецФункции

// Процедура, вызываемая из скрипта через com-соединение.
// Записывает результат проведенного копирования в настройки.
// 
// Параметры:
//	Результат - Булево - результат копирования.
//	ИмяФайлаРезервнойКопии - Строка - имя файла резервной копии.
//
Процедура ЗавершитьРезервноеКопирование(Результат, ИмяФайлаРезервнойКопии =  "") Экспорт
	
	СтруктураРезультата = НастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноКопирование = Истина;
	СтруктураРезультата.РезультатКопирования = Результат;
	СтруктураРезультата.ИмяФайлаРезервнойКопии = ИмяФайлаРезервнойКопии;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
	
КонецПроцедуры

// Вызывается из скрипта через com-соединение для
// записи результата проведенного восстановления ИБ в настройки.
//
// Параметры:
//	Результат - Булево - результат восстановления.
//
Процедура ЗавершитьВосстановление(Результат) Экспорт
	
	СтруктураРезультата = НастройкиРезервногоКопирования();
	СтруктураРезультата.ПроведеноВосстановление = Истина;
	УстановитьПараметрыРезервногоКопирования(СтруктураРезультата);
	
КонецПроцедуры

Функция ПараметрыУдаленияРезервныхКопийПоУмолчанию()
	
	ПараметрыУдаления = Новый Структура;
	
	ПараметрыУдаления.Вставить("ТипОграничения", "ПоПериоду");
	
	ПараметрыУдаления.Вставить("КоличествоКопий", 10);
	
	ПараметрыУдаления.Вставить("ЕдиницаИзмеренияПериода", "Месяц");
	ПараметрыУдаления.Вставить("ЗначениеВЕдиницахИзмерения", 6);
	
	Возврат ПараметрыУдаления;
	
КонецФункции

// Обновляет настройки резервного копирования.
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_1_15() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыРезервногоКопирования.Свойство("ПроводитьРезервноеКопированиеПриЗавершенииРаботы")
		Или Не ПараметрыРезервногоКопирования.Свойство("НастроеноПользователем") Тогда
		
		Возврат; // Уже было выполнено обновление.
		
	КонецЕсли;
	
	ВыборПунктаНастройки = ПараметрыРезервногоКопирования.ВыборПунктаНастройки;
	
	Если ВыборПунктаНастройки = 3 Тогда
		ВыборПунктаНастройки = 0;
	ИначеЕсли ВыборПунктаНастройки = 2 Тогда
		ВыборПунктаНастройки = 3;
	Иначе
		Если ПараметрыРезервногоКопирования.ПроводитьРезервноеКопированиеПриЗавершенииРаботы Тогда
			ВыборПунктаНастройки = 2;
		ИначеЕсли ПараметрыРезервногоКопирования.НастроеноПользователем И ЗначениеЗаполнено(ПараметрыРезервногоКопирования.РасписаниеКопирования) Тогда
			ВыборПунктаНастройки = 1;
		Иначе
			ВыборПунктаНастройки = 0;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыРезервногоКопирования.ВыборПунктаНастройки = ВыборПунктаНастройки;
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ЕжечасноеОповещение ");
	МассивУдаляемыхПараметров.Добавить("НастроеноПользователем ");
	МассивУдаляемыхПараметров.Добавить("ПроводитьРезервноеКопированиеПриЗавершенииРаботы");
	МассивУдаляемыхПараметров.Добавить("АвтоматическоеРезервноеКопирование");
	МассивУдаляемыхПараметров.Добавить("ОтложенноеРезервноеКопирование");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Обновляет настройки резервного копирования.
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_1_33() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПараметрыУдаления") Тогда
		
		Возврат; // Уже было выполнено обновление.
		
	КонецЕсли;
	
	ПараметрыУдаления = ПараметрыУдаленияРезервныхКопийПоУмолчанию();
	ПараметрыУдаления.ПроизводитьУдаление = ПараметрыРезервногоКопирования.ПроизводитьУдаление;
	ПараметрыУдаления.ТипОграничения = ?(ПараметрыРезервногоКопирования.УдалятьПоПериоду, "ПоПериоду", "ПоКоличеству");
	
	Если ПараметрыРезервногоКопирования.УдалятьПоПериоду Тогда
		ПараметрыУдаления.ТипОграничения = "ПоПериоду";
		НастройкиЗначенияПериода = ЗначениеПериодаПоИнтервалуВремени(ПараметрыРезервногоКопирования.ЗначениеПараметра);
		ПараметрыУдаления.ЕдиницаИзмеренияПериода = НастройкиЗначенияПериода.ТипПериода;
		ПараметрыУдаления.ЗначениеВЕдиницахИзмерения = НастройкиЗначенияПериода.ЗначениеПериода;
	Иначе
		ПараметрыУдаления.ТипОграничения = "ПоКоличеству";
		ПараметрыУдаления.КоличествоКопий = ПараметрыУдаления.ЗначениеПараметра;
	КонецЕсли;
	
	ПараметрыРезервногоКопирования.Вставить("ПараметрыУдаления", ПараметрыУдаления);
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ПроизводитьУдаление");
	МассивУдаляемыхПараметров.Добавить("УдалятьПоПериоду ");
	МассивУдаляемыхПараметров.Добавить("ЗначениеПараметра");
	МассивУдаляемыхПараметров.Добавить("ПериодОповещения");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Обновляет настройки резервного копирования.
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_2_33() Экспорт
	
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	
	Если ПараметрыРезервногоКопирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.Свойство("ВыполнятьАвтоматическоеРезервноеКопирование") Тогда
		
		Возврат; // Уже было выполнено обновление.
		
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.ПервыйЗапуск Тогда
		
		ПараметрыРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = Дата(1, 1, 1);
		
	КонецЕсли;
	
	Если ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 2 Тогда
		ВариантВыполнения = "ПриЗавершенииРаботы";
	Иначе
		ВариантВыполнения = "ПоРасписанию";
	КонецЕсли;
	
	ВыполнятьАвтоматическоеРезервноеКопирование = (ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 1 Или ПараметрыРезервногоКопирования.ВыборПунктаНастройки = 2);
	
	ПараметрыРезервногоКопирования.Вставить("ВыполнятьАвтоматическоеРезервноеКопирование", ВыполнятьАвтоматическоеРезервноеКопирование);
	ПараметрыРезервногоКопирования.Вставить("РезервноеКопированиеНастроено", ПараметрыРезервногоКопирования.ВыборПунктаНастройки <> 0);
	ПараметрыРезервногоКопирования.Вставить("ВариантВыполнения", ВариантВыполнения);
	ПараметрыРезервногоКопирования.Вставить("РучнойЗапускПоследнегоРезервногоКопирования", Истина);
	
	МассивУдаляемыхПараметров = Новый Массив;
	МассивУдаляемыхПараметров.Добавить("ВыборПунктаНастройки");
	МассивУдаляемыхПараметров.Добавить("ПервыйЗапуск");
	
	Для Каждого УдаляемыйПараметр Из МассивУдаляемыхПараметров Цикл
		
		Если ПараметрыРезервногоКопирования.Свойство(УдаляемыйПараметр) Тогда
			
			ПараметрыРезервногоКопирования.Удалить(УдаляемыйПараметр);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыРезервногоКопирования.Свойство("ПараметрыУдаления")
		И ПараметрыРезервногоКопирования.ПараметрыУдаления.Свойство("ПроизводитьУдаление") Тогда
		
		Если Не ПараметрыРезервногоКопирования.ПараметрыУдаления.ПроизводитьУдаление Тогда
			ПараметрыРезервногоКопирования.ПараметрыУдаления.ТипОграничения = "ХранитьВсе";
		КонецЕсли;
		
		ПараметрыРезервногоКопирования.ПараметрыУдаления.Удалить("ПроизводитьУдаление");
		
	КонецЕсли;
	
	УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

// Обновляет настройки резервного копирования.
//
Процедура ОбновитьПараметрыРезервногоКопирования_2_2_4_36() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	СохраненныйПользователь = Неопределено;
	Для Каждого Пользователь Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
		Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыРезервногоКопирования", "",,, Пользователь.Имя);
		
		Если ТипЗнч(Настройки) <> Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Настройки.Свойство("ВыполнятьАвтоматическоеРезервноеКопирование")
			И Настройки.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
			СохраненныйПользователь = Пользователь;
			Прервать;
		КонецЕсли;
		
		Если Настройки.Свойство("РезервноеКопированиеНастроено")
			И Настройки.РезервноеКопированиеНастроено Тогда
			СохраненныйПользователь = Пользователь;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СохраненныйПользователь <> Неопределено Тогда
		НайденныйПользователь = Неопределено;
		ПользователиСлужебный.ПользовательПоИдентификаторуСуществует(СохраненныйПользователь.УникальныйИдентификатор,, НайденныйПользователь);
		Если НайденныйПользователь <> Неопределено Тогда
			Параметры = Новый Структура("Пользователь", НайденныйПользователь);
			Константы.ПараметрыРезервногоКопирования.Установить(Новый ХранилищеЗначения(Параметры));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
