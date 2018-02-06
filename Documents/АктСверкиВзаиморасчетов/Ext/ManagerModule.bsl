﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПредставленияДокументовДляОрганизации()
	
	ВидыДокументовОрганизации = Новый Структура;
	
	ВидыДокументовОрганизации.Вставить("АвансовыйОтчет",				НСтр("ru = 'Авансовый отчет'"));
	ВидыДокументовОрганизации.Вставить("КорректировкаРегистров",		НСтр("ru = 'Корректировка задолженности'"));
	ВидыДокументовОрганизации.Вставить("ПлатежноеПоручениеВходящее",	НСтр("ru = 'Платежное поручение входящее'"));
	ВидыДокументовОрганизации.Вставить("ПриходныйКассовыйОрдер",		НСтр("ru = 'Приходный кассовый ордер'"));
	ВидыДокументовОрганизации.Вставить("ПлатежноеПоручениеИсходящее",	НСтр("ru = 'Платежное поручение исходящее'"));
	ВидыДокументовОрганизации.Вставить("РасходИзКассы",					НСтр("ru = 'Расход из кассы'"));
	ВидыДокументовОрганизации.Вставить("РасходныйКассовыйОрдер",		НСтр("ru = 'Расходный кассовый ордер'"));
	ВидыДокументовОрганизации.Вставить("РеализацияТоваровУслуг", 		НСтр("ru = 'Реализация (товаров, услуг)'"));
	ВидыДокументовОрганизации.Вставить("ПоступлениеТоваровУслуг", 		НСтр("ru = 'Поступление (товаров, услуг)'"));	
	ВидыДокументовОрганизации.Вставить("СчетНаОплатуПокупателю", 		НСтр("ru = 'Счет на оплату'"));
	ВидыДокументовОрганизации.Вставить("СчетФактураВыписанный", 		НСтр("ru = 'Счет-фактура (выданный)'"));
	ВидыДокументовОрганизации.Вставить("СчетФактураПолученный", 		НСтр("ru = 'Счет-фактура (полученный)'"));
	
	Возврат ВидыДокументовОрганизации;
	
КонецФункции // ПолучитьПредставленияДокументов()

Функция ОписаниеРасчетногоДокументаКонтрагента(ДокументСсылка, Знач НомерДокумента, Знач ДатаДокумента)
	
	// Номер и дату обработаем сразу, так как понадобиться и для пустой ссылки
	НомерДокумента	= ?(ПустаяСтрока(НомерДокумента), НСтр("ru = '_______'"), ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НомерДокумента, Ложь, Истина));
	ДатаДокумента	= ?(ЗначениеЗаполнено(ДатаДокумента), Формат(ДатаДокумента, "ДЛФ=D"), НСтр("ru = '___.___._______'"));
	
	Если ДокументСсылка = Неопределено Тогда
		СтрокаОписания = НСтр("ru = 'Расчетный документ № %1 от %2 г.'");
		СтрокаОписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОписания, НомерДокумента, ДатаДокумента);
		
		Возврат СтрокаОписания;
	КонецЕсли;
	
	// Описание документа
	ОписаниеДокумента = "";
	ПредставленияДокументовОрганизации = ПолучитьПредставленияДокументовДляОрганизации();
	ПредставленияДокументовОрганизации.Свойство(ДокументСсылка.Метаданные().Имя, ОписаниеДокумента);
	
	Если ПустаяСтрока(ОписаниеДокумента) Тогда
		ОписаниеДокумента = НСтр("ru = 'Расчетный документ'");
	КонецЕсли;
	
	// Добавка к описанию
	ДобавитьКОписанию = "";
	
	Возврат СтрШаблон(НСтр("ru = '%1 %2 № %3 от %4 г.'"), ОписаниеДокумента, ДобавитьКОписанию, НомерДокумента, ДатаДокумента);
	
КонецФункции // ОписаниеРасчетногоДокументаКонтрагента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой АктСверки
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьАктаСверки(МассивОбъектов, ОбъектыПечати)
	СписокДокументовСФ = Новый СписокЗначений;
	СписокДокументовСФ.Добавить("СчетФактураВыписанный");	
	СписокДокументовСФ.Добавить("СчетФактураПолученный");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктСверкиВзаиморасчетов.ДатаНачала,
	|	АктСверкиВзаиморасчетов.ДатаОкончания,
	|	АктСверкиВзаиморасчетов.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта,
	|	АктСверкиВзаиморасчетов.Контрагент,
	|	АктСверкиВзаиморасчетов.ДоговорКонтрагента,
	|	АктСверкиВзаиморасчетов.Организация,
	|	АктСверкиВзаиморасчетов.ПредставительОрганизации,
	|	АктСверкиВзаиморасчетов.ПредставительКонтрагента,
	|	АктСверкиВзаиморасчетов.ОстатокНаНачало,
	|	АктСверкиВзаиморасчетов.ОстатокНаКонец,
	|	АктСверкиВзаиморасчетов.СверкаСогласована,
	|	АктСверкиВзаиморасчетов.СверкаПоСоцФонду,
	|	АктСверкиВзаиморасчетов.ИсключитьИзПредставленияДокумента,
	|	АктСверкиВзаиморасчетов.СШапкойУтверждаю,
	|	АктСверкиВзаиморасчетов.ПечатьСчетФактурВместоДокументовРеализации,
	|	АктСверкиВзаиморасчетов.УчитыватьВзаимозачеты,
	|	АктСверкиВзаиморасчетов.Дата,
	|	АктСверкиВзаиморасчетов.Автор,
	|	АктСверкиВзаиморасчетов.Организация.ИНН КАК ИНН,
	|	АктСверкиВзаиморасчетов.Организация.КодПоОКПО КАК ОКПО,
	|	АктСверкиВзаиморасчетов.Организация.РегНомерСоцФонда КАК Рег,
	|	АктСверкиВзаиморасчетов.ПоДаннымОрганизации.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДокументСверки,
	|		СуммаДт,
	|		СуммаКт
	|	),
	|	АктСверкиВзаиморасчетов.ПоДаннымКонтрагента.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДокументСверки,
	|		СуммаДт,
	|		СуммаКт
	|	),
	|	АктСверкиВзаиморасчетов.СписокСчетов.(
	|		Ссылка,
	|		НомерСтроки,
	|		СчетУчета,
	|		УчаствуетВРасчетах
	|	)
	|ИЗ
	|	Документ.АктСверкиВзаиморасчетов КАК АктСверкиВзаиморасчетов
	|ГДЕ
	|	АктСверкиВзаиморасчетов.Ссылка В(&МассивОбъектов)";
	
	РезультатПакет =  Запрос.ВыполнитьПакет();	
		
	Шапка = РезультатПакет[0].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "АктСверкиВзаиморасчетов_АктСверки";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.АктСверкиВзаиморасчетов.ПФ_MXL_АктСверки");
	
	Пока Шапка.Следующий() цикл
		НазваниеОрганизации = Шапка.Организация.НаименованиеПолное;
		Если ПустаяСтрока(НазваниеОрганизации) Тогда
			НазваниеОрганизации = Шапка.Организация;
		КонецЕсли;
		
		НаименованиеКонтрагента = Шапка.Контрагент.НаименованиеПолное;
		Если ПустаяСтрока(НаименованиеКонтрагента) Тогда
			НаименованиеКонтрагента = Шапка.Контрагент;
		КонецЕсли;
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ДатаДокумента", Шапка.Дата);
		
		ТаблицаПоДаннымКонтрагента = Шапка.ПоДаннымКонтрагента.Выгрузить();
		ДанныеПечати.Вставить("СуммаДтКонтр", ТаблицаПоДаннымКонтрагента.Итог("СуммаДт"));
		ДанныеПечати.Вставить("СуммаКтКонтр", ТаблицаПоДаннымКонтрагента.Итог("СуммаКт"));
		
		ТаблицаПоДаннымОрганизации = Шапка.ПоДаннымОрганизации.Выгрузить();
		ДанныеПечати.Вставить("СуммаДт", ТаблицаПоДаннымОрганизации.Итог("СуммаДт"));
		ДанныеПечати.Вставить("СуммаКт", ТаблицаПоДаннымОрганизации.Итог("СуммаКт"));
		
		ДанныеПечати.Вставить("НазваниеОрганизации", СокрЛП(НазваниеОрганизации));
		ДанныеПечати.Вставить("НаименованиеКонтрагента", СокрЛП(НаименованиеКонтрагента));
		ОписаниеПериода = "Период: " + ПредставлениеПериода(НачалоДня(Шапка.ДатаНачала), КонецДня(Шапка.ДатаОкончания), "ФП = Истина");
		ИмяПредставителяОрганизации = Шапка.ПредставительОрганизации;
		ИмяПредсатвителяКонтрагента = Шапка.ПредставительКонтрагента;
		
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'сверки взаиморасчетов между %1 %2 и %3 с %4 по %5'"), 
								СокрЛП(НазваниеОрганизации), 
								Символы.ПС,
								СокрЛП(НаименованиеКонтрагента),
								Формат(Шапка.ДатаНачала, "ДЛФ=D"),
								Формат(Шапка.ДатаОкончания, "ДЛФ=D"));

		Если ЗначениеЗаполнено(Шапка.ДоговорКонтрагента) Тогда
			ТекстЗаголовка = ТекстЗаголовка + СтрШаблон(НСтр("ru = '%1 по договору %2'"),
													Символы.ПС,
													СокрЛП(Шапка.ДоговорКонтрагента.Наименование));
		КонецЕсли;
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		
		ДанныеПредставителяОрганизации =БухгалтерскийУчетСервер.ДанныеФизЛица(Шапка.Организация, ИмяПредставителяОрганизации, Шапка.Дата);
		ФИОПредставителя = ?(ЗначениеЗаполнено(ДанныеПредставителяОрганизации.Должность), ДанныеПредставителяОрганизации.Должность, "")
				+ " " + ДанныеПредставителяОрганизации.Представление;
		
		НачОстДебет  = ?(Шапка.ОстатокНаНачало > 0, Шапка.ОстатокНаНачало, 0);
		НачОстКредит = ?(Шапка.ОстатокНаНачало < 0, -Шапка.ОстатокНаНачало, 0);
		
		ОстатокНаКонецК = Шапка.ОстатокНаНачало + ТаблицаПоДаннымОрганизации.Итог("СуммаДт") -  ТаблицаПоДаннымОрганизации.Итог("СуммаКт");
		
		КонОстДебет  = ?(ОстатокНаКонецК > 0, ОстатокНаКонецК, 0);
		КонОстКредит = ?(ОстатокНаКонецК < 0, -ОстатокНаКонецК, 0);
		
		ОстатокНаКонецК = -Шапка.ОстатокНаНачало + ТаблицаПоДаннымКонтрагента.Итог("СуммаДт") -  ТаблицаПоДаннымКонтрагента.Итог("СуммаКт");
		
		КонОстДебетК  = ?(ОстатокНаКонецК > 0, ОстатокНаКонецК, 0);
		КонОстКредитК = ?(ОстатокНаКонецК < 0, -ОстатокНаКонецК, 0);
		
		ДанныеПечати.Вставить("СуммаНачальныйОстатокДт", НачОстДебет);
		ДанныеПечати.Вставить("СуммаНачальныйОстатокКт", НачОстКредит);
		
		Если КонОстДебет <> 0 Тогда 
			ДанныеПечати.Вставить("СуммаКонечныйОстатокДт", КонОстДебет);
		Иначе
			ДанныеПечати.Вставить("СуммаКонечныйОстатокДт", "0,00");
		КонецЕсли;	
		Если КонОстКредит <> 0 Тогда 
			ДанныеПечати.Вставить("СуммаКонечныйОстатокКт", КонОстКредит);
		Иначе
			ДанныеПечати.Вставить("СуммаКонечныйОстатокКт", "0,00");
		КонецЕсли;	
		
		Если Шапка.СверкаСогласована тогда
			Если КонОстДебетК <> 0 Тогда 
				ДанныеПечати.Вставить("СуммаКонечныйОстатокДтКонтр", КонОстДебетК);
			Иначе
				ДанныеПечати.Вставить("СуммаКонечныйОстатокДтКонтр", "0,00");
			КонецЕсли;	
			Если КонОстКредитК <> 0 Тогда 
				ДанныеПечати.Вставить("СуммаКонечныйОстатокКтКонтр", КонОстКредитК);
			Иначе
				ДанныеПечати.Вставить("СуммаКонечныйОстатокКтКонтр", "0,00");
			КонецЕсли;	
		КонецЕсли;
		
		// Результаты сверки
		Если Не ЗначениеЗаполнено(Шапка.Валюта) ТОгда
			ВалютаРезультата = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		Иначе
			ВалютаРезультата = Шапка.Валюта;
		КонецЕсли;
		
		//Если сверка не согласована, то результат сверки не выводить 
		Если Шапка.СверкаСогласована Тогда
			Если ТаблицаПоДаннымОрганизации.Количество() = 0 Тогда			
				РезультатыСверки = СтрШаблон(НСтр("ru = 'Задолженность %1 перед %2 на %3 составляет %4 %5'"), 
										СокрЛП(НазваниеОрганизации),
										НаименованиеКонтрагента,
										Формат(Шапка.ДатаОкончания,"ДЛФ=D"),
										Формат(ОстатокНаКонецК, "ЧЦ=21; ЧДЦ=2"),
										Строка(ВалютаРезультата));
				
				Сумма = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ОстатокНаКонецК, ВалютаРезультата);
				СуммаПрописью = "( "+Сумма+" )";
				
			Иначе                                                                                                                                                                                         
				Если ОстатокНаКонецК < 0  Тогда
					РезультатыСверки = СтрШаблон(НСтр("ru = 'Задолженность %1 перед %2 на %3 составляет %4 %5'"), 
										СокрЛП(НаименованиеКонтрагента),
										СокрЛП(НазваниеОрганизации),
										Формат(Шапка.ДатаОкончания,"ДЛФ=D"),
										Формат(Шапка.ОстатокНаКонецК, "ЧЦ=21; ЧДЦ=2"),
										Строка(ВалютаРезультата));
					
					Сумма = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.ОстатокНаКонецК, ВалютаРезультата);
					СуммаПрописью = "( "+Сумма+" )";
					
				ИначеЕсли ОстатокНаКонецК > 0   Тогда
					РезультатыСверки = СтрШаблон(НСтр("ru = 'Задолженность %1 перед %2 на %3 составляет %4 %5'"), 
										СокрЛП(НазваниеОрганизации),
										НаименованиеКонтрагента,
										Формат(Шапка.ДатаОкончания,"ДЛФ=D"),
										Формат(Шапка.ОстатокНаКонецК, "ЧЦ=21; ЧДЦ=2"),
										Строка(ВалютаРезультата));
										
					Сумма = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ОстатокНаКонецК, ВалютаРезультата);
					СуммаПрописью = "( "+Сумма+" )";
					
				Иначе
					РезультатыСверки = НСтр("ru = 'Взаиморасчет.'");                
					СуммаПрописью = "";
				КонецЕсли;
			КонецЕсли;
			
			ДанныеПечати.Вставить("РезультатыСверки", РезультатыСверки);
			ДанныеПечати.Вставить("СуммаПрописью", СуммаПрописью); 				
		КонецЕсли; 

		// Инициализация массива областей макета
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("ШапкаУтверждаю");
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("НачальноеСальдо");
		МассивОбластейМакета.Добавить("Обороты");
		МассивОбластейМакета.Добавить("СФ");
		МассивОбластейМакета.Добавить("ПустаяСтрока");
		МассивОбластейМакета.Добавить("ОборотыИтог");
		МассивОбластейМакета.Добавить("КонОстатки");
		МассивОбластейМакета.Добавить("Подвал");
		
		ТабличныйДокумент.Очистить();

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "ШапкаУтверждаю" и Шапка.СШапкойУтверждаю Тогда 
				Руков = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата);
				ДанныеПечати.Вставить("Должность", Руков.РуководительДолжностьСсылка);
				ДанныеПечати.Вставить("ДиректорПредприятия", Руков.Руководитель);
				ТабличныйДокумент.Вывести(ОбластьМакета);	
			ИначеЕсли ИмяОбласти <> "Обороты" и ИмяОбласти <> "СФ" И ИмяОбласти <> "ПустаяСтрока" 
				И ИмяОбласти <> "ШапкаУтверждаю" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "ПустаяСтрока" и Не Шапка.СверкаСогласована Тогда
				НачальныйНомер = 1;
				Для Итерация = 1 По 5 Цикл
					ТабличныйДокумент.Вывести(ОбластьМакета);
					НачальныйНомер = НачальныйНомер + 1;
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "Обороты" Тогда
				сч = 0;
				Для Каждого СтрокаТЧ из ТаблицаПоДаннымОрганизации Цикл
					Регистратор = 	СтрокаТЧ.ДокументСверки;
					ОбластьМакета.Параметры.СуммаОборотДт = СтрокаТЧ.СуммаДт;
					ОбластьМакета.Параметры.СуммаОборотКт = СтрокаТЧ.СуммаКт;
					Если  НЕ СтрокаТЧ.ДокументСверки  = Неопределено И Не Шапка.ИсключитьИзПредставленияДокумента Тогда
						НомерДокумента = ОписаниеРасчетногоДокументаКонтрагента(СтрокаТЧ.ДокументСверки, СтрокаТЧ.ДокументСверки.Номер, СтрокаТЧ.ДокументСверки.Дата);
						ОбластьМакета.Параметры.РегистраторПредставление = НомерДокумента + ?(СтрокаТЧ.ДокументСверки.Комментарий = "", "", "
						|" + СтрокаТЧ.ДокументСверки.Комментарий);
					ИначеЕсли НЕ СтрокаТЧ.ДокументСверки  = Неопределено И Шапка.ИсключитьИзПредставленияДокумента Тогда
						ОбластьМакета.Параметры.РегистраторПредставление = ?(СтрокаТЧ.ДокументСверки.Комментарий = "", "", "" + СтрокаТЧ.ДокументСверки.Комментарий);
					КонецЕсли;
					ОбластьМакета.Параметры.Регистратор = СтрокаТЧ.ДокументСверки;
					ОбластьМакета.Параметры.СуммаОборотДтКонтр = СтрокаТЧ.СуммаКт;
					ОбластьМакета.Параметры.СуммаОборотКтКонтр = СтрокаТЧ.СуммаДт;
			
					
					// Печать доков для авансового отчета
					Если Не СтрокаТЧ = Неопределено Тогда 
						Если ТипЗнч(СтрокаТЧ.ДокументСверки) = ТипЗнч(Документы.АвансовыйОтчет.ПустаяСсылка()) Тогда 
							РеквизитыАО = "";
							Для каждого СТЧ Из СтрокаТЧ.ДокументСверки.ОплатаПоставщикам Цикл
								Если СТЧ.Контрагент <> Шапка.Контрагент Тогда 
									Продолжить;
								КонецЕсли;						
								РеквизитыАОтекущие  = ?(ЗначениеЗаполнено(СТЧ.ВидДокВходящий), СТЧ.ВидДокВходящий, "")
								+ ?(ЗначениеЗаполнено(СТЧ.НомерВходящегоДокумента), " №" + СТЧ.НомерВходящегоДокумента,"")
								+ ?(ЗначениеЗаполнено(СТЧ.ДатаВходящегоДокумента), " от " + Формат(СТЧ.ДатаВходящегоДокумента,"ДФ=dd.MM.yy"),"");
								
								РеквизитыАО = РеквизитыАО + ?(ЗначениеЗаполнено(РеквизитыАОтекущие), ". " + РеквизитыАОтекущие, "");
							КонецЦикла;
							
							ОбластьМакета.Параметры.РегистраторПредставление = ОбластьМакета.Параметры.РегистраторПредставление + РеквизитыАО;
						КонецЕсли;
					КонецЕсли;
					
					
					// Печать реквизитов счетов-фактур
					Если Не СтрокаТЧ = Неопределено Тогда 
						Если НЕ Шапка.СверкаПоСоцФонду 
							И БухгалтерскийУчетСервер.ЕстьРеквизитДокумента("СерияБланкаСФ", СтрокаТЧ.ДокументСверки.Метаданные()) 
							И ЗначениеЗаполнено(СтрокаТЧ.ДокументСверки.СерияБланкаСФ) Тогда 
							
							РеквизитыСФ = "Счет-фактура " + СтрокаТЧ.ДокументСверки.СерияБланкаСФ + " № " + СтрокаТЧ.ДокументСверки.НомерБланкаСФ
							+ " от " + Формат(СтрокаТЧ.ДокументСверки.ДатаСФ,"ДФ=dd.MM.yyyy"); 
						Иначе
							РеквизитыСФ = "";
						КонецЕсли;				
					КонецЕсли;

					Если Шапка.ПечатьСчетФактурВместоДокументовРеализации И ЗначениеЗаполнено(РеквизитыСФ) Тогда 
						ОбластьМакета.Параметры.РегистраторПредставление = РеквизитыСФ;
						
					ИначеЕсли ОбластьМакета.Параметры.РегистраторПредставление <> Неопределено Тогда 
						ОбластьМакета.Параметры.РегистраторПредставление = ОбластьМакета.Параметры.РегистраторПредставление + " " + РеквизитыСФ;
						
					Иначе
						ОбластьМакета.Параметры.РегистраторПредставление = "";
						
					КонецЕсли;				
					
					сч = сч + 1;
					ОбластьМакета.Параметры.НомерСтроки = сч;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;	
			ИначеЕсли ИмяОбласти = "СФ" Тогда   	

			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;		
	Возврат ТабличныйДокумент;		
	
КонецФункции

// Функция формирует табличный документ с печатной формой АктСверкиСФ
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьАктаСверкиСФ(МассивОбъектов, ОбъектыПечати)
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка,
		|	ТаблицаДокумента.Номер,
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента,
		|	ТаблицаДокумента.ДоговорКонтрагента.ВалютаРасчетов КАК Валюта,
		|	ТаблицаДокумента.ПредставительОрганизации,
		|	ТаблицаДокумента.ПредставительКонтрагента,
		|	ТаблицаДокумента.ОстатокНаНачало,
		|	ТаблицаДокумента.ОстатокНаКонец,
		|	ТаблицаДокумента.СверкаСогласована,
		|	ТаблицаДокумента.СверкаПоСоцФонду,
		|	ТаблицаДокумента.ИсключитьИзПредставленияДокумента,
		|	ТаблицаДокумента.СШапкойУтверждаю,
		|	ТаблицаДокумента.ПечатьСчетФактурВместоДокументовРеализации,
		|	ТаблицаДокумента.УчитыватьВзаимозачеты,
		|	ТаблицаДокумента.ПоДаннымОрганизации.(
		|		Ссылка,
		|		НомерСтроки,
		|		ДокументСверки,
		|		СуммаДт,
		|		СуммаКт
		|	),
		|	ТаблицаДокумента.ПоДаннымКонтрагента.(
		|		Ссылка,
		|		НомерСтроки,
		|		ДокументСверки,
		|		СуммаДт,
		|		СуммаКт
		|	),
		|	ТаблицаДокумента.СписокСчетов.(
		|		Ссылка,
		|		НомерСтроки,
		|		СчетУчета,
		|		УчаствуетВРасчетах
		|	),
		|	ТаблицаДокумента.Организация.ИНН КАК ИНН,
		|	ТаблицаДокумента.Организация.КодПоОКПО КАК ОКПО,
		|	ТаблицаДокумента.Организация.РегНомерСоцФонда КАК Рег
		|ИЗ
		|	Документ.АктСверкиВзаиморасчетов КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&МассивОбъектов)";	
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "АктСверкиВзаиморасчетов_АктСверкиСФ";

	ТабличныйДокумент.Очистить();
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.АктСверкиВзаиморасчетов.ПФ_MXL_АктСверкиСФ");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ДатаДокумента", Шапка.Дата);
		ДанныеПечати.Вставить("Организация", Шапка.Организация.НаименованиеПолное);
		ДанныеПечати.Вставить("Рег", Шапка.Рег);
		ДанныеПечати.Вставить("ИНН", Шапка.ИНН);
		ДанныеПечати.Вставить("ОКПО", Шапка.ОКПО);

		// Инициализация массива областей макета
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("ДеталиТаблицы");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Подписи");
		
		СписокСчетовСоцФонда = Шапка.СписокСчетов.Выгрузить();
		СписокСчетовСоцФонда.Свернуть("СчетУчета");

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТиповойОстаткиИОбороты.Счет,
		|	ТиповойОстаткиИОбороты.СуммаНачальныйОстатокДт - ТиповойОстаткиИОбороты.СуммаНачальныйОстатокКт КАК ОстН,
		|	ТиповойОстаткиИОбороты.СуммаКонечныйОстатокДт - ТиповойОстаткиИОбороты.СуммаКонечныйОстатокКт КАК ОстК
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, , , Счет = &СчетФС, , Организация = &Организация) КАК ТиповойОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокКт КАК ОстН,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК ОстК
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Период, ДвиженияИГраницыПериода, Счет В (&СчетаСоцФонда), , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК НСтрахВзн,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК УСтрахВзн
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Период, ДвиженияИГраницыПериода, Счет В (&СчетаСоцФонда), , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК ФинС
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, , , Счет = &СчетФС, , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК НСтрахВзн,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК УСтрахВзн
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Период, ДвиженияИГраницыПериода, Счет В (&СчетаСоцФонда), , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокКт КАК ОстН,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК ФСК
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, , , Счет = &СчетФС, , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.Счет,
		|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокКт КАК ОстН,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт - ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокКт КАК ОстК
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Период, ДвиженияИГраницыПериода, Счет В (&СчетаСоцФонда), , Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты";

		Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Шапка.ДатаНачала));
		Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Шапка.ДатаОкончания));	
		Запрос.УстановитьПараметр("СчетФС", ПланыСчетов.Хозрасчетный.Финсанкции);
		Запрос.УстановитьПараметр("Организация", Шапка.Организация);
		Запрос.УстановитьПараметр("СчетаСоцФонда", СписокСчетовСоцФонда);
		
		Результат = Запрос.ВыполнитьПакет();
		ТЗФ = Результат[0].Выгрузить();

		// финсанкции  1
		ОстН = ТЗФ.Итог("ОстН");
		Если ОстН > 0 Тогда 
			ОстНДт 	= ОстН;
			ОстККт 	= 0;
		Иначе
			ОстНДт 	= 0;
			ОстНКт 	= -ОстН;
		КонецЕсли;		
		
		ДанныеПечати.Вставить("ФинсанкцНДтПлательщик", ОстНДт);
		ДанныеПечати.Вставить("ФинсанкцНКтПлательщик", ОстНКт);	
		ДанныеПечати.Вставить("ФинсанкцНДтСФ", ОстНКт);
		ДанныеПечати.Вставить("ФинсанкцНКтСФ", ОстНДт);

		//  Остатки СФ на начало
		ТЗН = Результат[1].Выгрузить();  
		ОстН = ТЗН.Итог("ОстН") + ТЗФ.Итог("ОстН");
			
		Если ОстН >0 Тогда 
			ОстНДт 	= ОстН ;
			ОстНКт 	= 0;
		Иначе
			ОстНДт 	= 0;
			ОстНКт 	= -ОстН;
		КонецЕсли;		
	    ДанныеПечати.Вставить("ОстНДтПлательщик", ОстНДт);
		ДанныеПечати.Вставить("ОстНКтПлательщик", ОстНКт);	
		ДанныеПечати.Вставить("ОстНДтСФ", ОстНКт);
		ДанныеПечати.Вставить("ОстНКтСФ", ОстНДт);

		ТЗС = Результат[2].Выгрузить();
		НСтрахВзн = ТЗС.Итог("НСтрахВзн");

	    ДанныеПечати.Вставить("ВзносыКтПлательшик", НСтрахВзн);	
		ДанныеПечати.Вставить("ВзносыДтСФ", НСтрахВзн);

	    // Начислено финсанкции	
		ТЗ = Результат[3].Выгрузить();
		ФинС = ТЗ.Итог("ФинС");
		Если ФинС >0 Тогда 
			ОстНКт 	= ФинС;
			ОстНДт 	= 0;
		Иначе
			ОстНКт 	= 0;
			ОстНДт 	= -ФинС;
		КонецЕсли;		
	    
		ДанныеПечати.Вставить("СанкцииКтПлательшик", ОстНКт);
		ДанныеПечати.Вставить("СанкцииДтПлательшик", ОстНДт);
		ДанныеПечати.Вставить("СанкцииДтСФ", ОстНКт);
		ДанныеПечати.Вставить("СанкцииКтСФ", ОстНДт);
		
	    //  Начислено всего
		НВсего = ТЗС.Итог("НСтрахВзн") + ТЗ.Итог("ФинС");
		
		Если НВсего >0 Тогда 
			НВсегоКт 	= НВсего;
			НВсегоДт 	= 0;
		Иначе
			НВсегоДт 	= 0;
			НВсегоКт 	= -НВсего;
		КонецЕсли;		
	    ДанныеПечати.Вставить("НВсегоДтПлательщик", НВсегоДт);
		ДанныеПечати.Вставить("НВсегоКтПлательщик", НВсегоКт);	
		ДанныеПечати.Вставить("НВсегоДтСФ", НВсегоКт);
		ДанныеПечати.Вставить("НВсегоКтСФ", НВсегоДт);
		
		// Уплачено всего
		ТЗС = Результат[4].Выгрузить();
		УСтрахВзн = ТЗС.Итог("УСтрахВзн");
		Если УСтрахВзн >0 Тогда 
			 УСтрахВзнДт 	= УСтрахВзн;
			 УСтрахВзнКт 	= 0;
		Иначе
			 УСтрахВзнДт 	= 0;
			 УСтрахВзнКт 	= -УСтрахВзн;
		КонецЕсли;		

	    ДанныеПечати.Вставить("УВсегоДтПлательщик", УСтрахВзнДт);	
		ДанныеПечати.Вставить("УВсегоКтПлательщик", УСтрахВзнКт);
		ДанныеПечати.Вставить("УВсегоКтСФ", УСтрахВзнДт);
		ДанныеПечати.Вставить("УВсегоДтСФ", УСтрахВзнКт);
		
		ДанныеПечати.Вставить("ДСДтПлательшик", УСтрахВзнДт);
		ДанныеПечати.Вставить("ДСКтПлательшик", УСтрахВзнКт);
		ДанныеПечати.Вставить("ДСКтСФ", УСтрахВзнДт);
		ДанныеПечати.Вставить("ДСДтСФ", УСтрахВзнКт);

		//  ФинСанкции на конец 
		ТЗи = Результат[5].Выгрузить();
		ФСК = ТЗи.Итог("ФСК");
		Если ФСК > 0 Тогда 
			ФСККт 	= ФСК;
			ФСКДт 	= 0;
		Иначе
			ФСКДт 	= 0;
			ФСККт 	= -ФСК;
		КонецЕсли;		
	    ДанныеПечати.Вставить("ФинсанкцККтПлательщик", ФСККт);
		ДанныеПечати.Вставить("ФинсанкцКДтПлательщик", ФСКДт);
		ДанныеПечати.Вставить("ФинсанкцКДтСФ", ФСККт);	
		ДанныеПечати.Вставить("ФинсанкцККтСФ", ФСКДт);	   
		
		ТЗ = Результат[6].Выгрузить();
		ОстК = ТЗ.Итог("ОстК") + ТЗи.Итог("ФСК");
		Если ОстК > 0 Тогда 
			ОстКДт 	= ОстК;
			ОстККт 	= 0;
		Иначе
			ОстКДт 	= 0;
			ОстККт 	= -ОстК;
		КонецЕсли;		
	    ДанныеПечати.Вставить("ОстКДтПлательщик", ОстКДт);
		ДанныеПечати.Вставить("ОстККтПлательщик", ОстККт);	
		ДанныеПечати.Вставить("ОстКДтСФ", ОстККт);
		ДанныеПечати.Вставить("ОстККтСФ", ОстКДт);
		
		Впользу = ОстКДт;
		Если Впользу > 0 Тогда 
			Впользу 	= "Плательщика";
			СуммаДляВывода = ОстКДт
		Иначе
			Впользу 	   = НСтр("ru = 'Социального Фонда'");
			СуммаДляВывода = ОстККт
		КонецЕсли;		
	   	ДанныеПечати.Вставить("Кого", Впользу);
		
		ДанныеПечати.Вставить("Число", Формат(Шапка.Дата, "ДФ=dd.MM.yy"));

	    ПрописьЧисла = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(СуммаДляВывода, , Ложь);
	    ДанныеПечати.Вставить("Сумма", ПрописьЧисла);

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "ДеталиТаблицы" Или ИмяОбласти = "Подвал" Или ИмяОбласти = "Заголовок" Тогда 
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСверки") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"АктСверки", НСтр("ru = 'Акт сверки'"), ПечатьАктаСверки(МассивОбъектов, ОбъектыПечати),,
		"Документ.АктСверкиВзаиморасчетов.ПФ_MXL_АктСверки");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСверкиСФ") Тогда	
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"АктСверкиСФ", НСтр("ru = 'Акт сверки соцФонда'"), ПечатьАктаСверкиСФ(МассивОбъектов, ОбъектыПечати),,
		"Документ.АктСверкиВзаиморасчетов.ПФ_MXL_АктСверкиСФ");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	 	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСверки";
	КомандаПечати.Представление = НСтр("ru = 'Акт сверки'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСверкиСФ";
	КомандаПечати.Представление = НСтр("ru = 'Акт сверки соцФонда'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли