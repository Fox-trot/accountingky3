﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Организация");
	БлокируемыеРеквизиты.Добавить("Владелец");
	БлокируемыеРеквизиты.Добавить("ВалютаРасчетов");
	БлокируемыеРеквизиты.Добавить("ВидДоговора");
	БлокируемыеРеквизиты.Добавить("ВидПоставкиНДС");
	БлокируемыеРеквизиты.Добавить("СтавкаНДС");
	БлокируемыеРеквизиты.Добавить("СтавкаНСП");
	БлокируемыеРеквизиты.Добавить("СтавкаНСПУслуги");
	БлокируемыеРеквизиты.Добавить("СуммаВключаетНалоги");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции 

// Получает договор контрагента по умолчанию с учетом условий отбора. Возвращается основной договор или единственный или пустую ссылку.
//
// Параметры
//  Контрагент	–	<СправочникСсылка.Контрагенты> 
//							Контрагент, договор которого нужно получить
//  Организация	–	<СправочникСсылка.Организации> 
//							Организация, договор которой нужно получить
//  СписокВидовДоговора	–	<Массив> или <СписокЗначений>, состоящий из значений типа <ПеречислениеСсылка.ВидыДоговоров> 
//							Нужные виды договора
//
// Возвращаемое значение:
//   <СправочникСсылка.ДоговорыКонтрагентов> – найденный договор или пустая ссылка
//
Функция ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговора = Неопределено) Экспорт
	
	ОсновнойДоговорКонтрагента = Контрагент.ОсновнойДоговорКонтрагента;
	
	Если СписокВидовДоговора = Неопределено
		ИЛИ (СписокВидовДоговора.НайтиПоЗначению(ОсновнойДоговорКонтрагента.ВидДоговора) <> Неопределено
		И ОсновнойДоговорКонтрагента.Организация = Организация) Тогда
		
		Возврат ОсновнойДоговорКонтрагента;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Владелец = &Контрагент
	|	И ДоговорыКонтрагентов.Организация = &Организация
	|	И ДоговорыКонтрагентов.ПометкаУдаления = Ложь"
	+?(СписокВидовДоговора <> Неопределено,"
	|	И ДоговорыКонтрагентов.ВидДоговора В (&СписокВидовДоговора)","");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокВидовДоговора", СписокВидовДоговора);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Выборка.Следующий();
	Возврат Выборка.Ссылка;

КонецФункции // ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора()

// Проверяет договор контрагента на соответствие переданным параметрам.
//
// Параметры
//	ТекстСообщения - <Строка> - текст сообщения об ошибках
//	Договор	–	<СправочникСсылка.ДоговорыКонтрагентов> - проверяемый договор
//	Организация	–	<СправочникСсылка.Организации> - организация документа
//	Контрагент	–	<СправочникСсылка.Контрагенты> - контрагент документа
//	СписокВидовДоговора	–	<СписокЗначений>, состоящий из значений типа <ПеречислениеСсылка.ВидыДоговоров>. 
//							Нужные виды договора.
//
// Возвращаемое значение:
//	<Булево> – Истина, если проверка пройдена успешно.
//
Функция ДоговорСоответствуетУсловиямДокумента(ТекстСообщения, Договор, Организация, Контрагент, СписокВидовДоговора) Экспорт
	
	ТекстСообщения = "";
	
	Если Не Контрагент.ВестиРасчетыПоДоговорам Тогда
		Возврат Истина;
	КонецЕсли;
	
	НеСоответствуетОрганизация = Ложь;
	НеСоответствуетВидДоговора = Ложь;
	
	Если Договор.Организация <> Организация Тогда
		НеСоответствуетОрганизация = Истина;
	КонецЕсли;
		
	Если СписокВидовДоговора.НайтиПоЗначению(Договор.ВидДоговора) = Неопределено Тогда
		НеСоответствуетВидДоговора = Истина;
	КонецЕсли;
	
	Если (НеСоответствуетОрганизация ИЛИ НеСоответствуетВидДоговора) = Ложь Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Реквизиты договора не соответствуют условиям документа:'");
	
	Если НеСоответствуетОрганизация Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = '
		| - Не совпадает организация'");
	КонецЕсли;
	
	Если НеСоответствуетВидДоговора Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = '
		| - Не совпадает вид договора'");
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // ДоговорСоответствуетУсловиямДокумента()

// Возвращает список доступных видов договора для документа.
//
// Параметры
//	Документ  - любой документ, предусматривающий договор контрагента
//	ВидОперации  - вид операции документа.
//
// Возвращаемое значение:
//	<СписокЗначений>   - список видов договора, доступных для документа.
//
Функция ПолучитьСписокВидовДоговораДляДокумента(Документ, ВидОперации = Неопределено, ИмяТабличнойЧасти = "") Экспорт
	
	СписокВидовДоговора = Новый СписокЗначений;
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ВводНачальныхОстатков") Тогда
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")
		Или ТипЗнч(Документ) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		Или ТипЗнч(Документ) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		
		СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ДополнительныеРасходы") 
		ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") 
		ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ПлатежноеПоручениеВходящее") Тогда
		
		Если ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
			ИЛИ ВидОперации = Перечисления.ВидыОперацийППВ.ВозвратОтПоставщика Тогда
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
		Иначе
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
	Или ТипЗнч(Документ) = Тип("ДокументСсылка.ДополнительныеРасходы")
	Или ТипЗнч(Документ) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") 
		ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") Тогда
		
		Если ВидОперации = Перечисления.ВидыОперацийРКО.ОплатаПоставщику 
			ИЛИ ВидОперации = Перечисления.ВидыОперацийППИ.ОплатаПоставщику Тогда
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
		Иначе
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокВидовДоговора;
	
КонецФункции // ПолучитьСписокВидовДоговораДляДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция составляет наименование договора.
//
Функция НаименованиеДоговора(ВалютаРасчетов, НомерДоговора = "") Экспорт 
	
	Если НомерДоговора = "" Тогда 
		НомерДоговора = "Основной";
	КонецЕсли;	
	
	Возврат СтрШаблон(НСтр("ru = '%1 (%2)'"), 
			СокрЛП(Строка(НомерДоговора)),
			СокрЛП(Строка(ВалютаРасчетов))
	);
	
КонецФункции // НаименованиеДоговора()

#КонецОбласти

#КонецЕсли