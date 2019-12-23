﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("Имя, Представление", "АнализДвиженийДенежныхСредств", НСтр("ru = 'Анализ движений денежных средств.'")));
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализДвиженийДенежныхСредств");
	НастройкиВарианта.Описание = НСтр("ru = 'Анализ движений денежных средств.'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
							
	Возврат Результат;
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Анализ движений денежных средств" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	Если ПараметрыОтчета.ПоказательПоступление Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "СуммаПриход");
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "СуммаРасход");
	КонецЕсли;
	
	Если Не ПараметрыОтчета.ПоказательПоступление
		И ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "СуммаРасход",, ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательПоступление
		И Не ПараметрыОтчета.ПоказательРасход Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "СуммаПриход",, ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Отключить расшифровки для всех ячеек кроме ДокументОплаты, 
	// также по этой строке установить для всех ячеек расшифровку аналогичную полю ДокументОплаты.
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
		Если Макет.Параметры.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаМакета Из Макет.Макет Цикл
			Для Каждого ЯчейкаМакета Из СтрокаМакета.Ячейки Цикл
				Если ЯчейкаМакета.Элементы.Количество() > 0 Тогда
					ЭтоПолеДокументОплаты = Ложь;
					ЗначениеПараметра = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ЯчейкаМакета.Оформление.Элементы, "Расшифровка");
					Если ЗначениеПараметра <> Неопределено И ЗначениеПараметра.Использование Тогда
						ПараметрРасшифровки = Макет.Параметры[Строка(ЗначениеПараметра.Значение)];
						Для Каждого ВыражениеПоля Из ПараметрРасшифровки.ВыраженияПолей Цикл
							Если ВыражениеПоля.Выражение = "ОсновнойНабор.ДокументОплаты" Тогда
								ЭтоПолеДокументОплаты = Истина;
								Для Каждого Параметр Из Макет.Параметры Цикл
									Если ТипЗнч(Параметр) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда
										Параметр.ВыраженияПолей.Очистить();
										
										НовоеВыражениеПоля = Параметр.ВыраженияПолей.Добавить();
										НовоеВыражениеПоля.Выражение = "ОсновнойНабор.ДокументОплаты";
										НовоеВыражениеПоля.Поле      = "ДокументОплаты";
									КонецЕсли;
								КонецЦикла;
								
								Прервать;
							КонецЕсли;
						КонецЦикла;
						Если Не ЭтоПолеДокументОплаты Тогда
							ЗначениеПараметра.Использование = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета, ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Формирует таблицу данных для монитора руководителя по организации за период
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаКон - Дата - дата конца периода
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ПолучитьДвижениеДенежныхСредствДляМонитораРуководителя(Организация, ДатаКон) Экспорт 
	
	НачалоГода            = НачалоГода(ДатаКон);
	НачалоМесяца          = НачалоМесяца(ДатаКон);
	НачалоПрошлогоМесяца  = ДобавитьМесяц(НачалоМесяца, -1);
	КонецПрошлогоМесяца   = КонецМесяца(НачалоПрошлогоМесяца);
	НачалоПрошлогоПериода = НачалоГода(НачалоПрошлогоМесяца);
	КонецПериода          = КонецДня(ДатаКон);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("НачалоГода",            НачалоГода);
	Запрос.УстановитьПараметр("НачалоМесяца",          НачалоМесяца);
	Запрос.УстановитьПараметр("НачалоПрошлогоМесяца",  НачалоПрошлогоМесяца);
	Запрос.УстановитьПараметр("НачалоПрошлогоПериода", НачалоПрошлогоПериода);
	Запрос.УстановитьПараметр("КонецПрошлогоМесяца",   КонецПрошлогоМесяца);
	Запрос.УстановитьПараметр("КонецПериода",          КонецПериода);
	Запрос.УстановитьПараметр("КонецПериодаГраница",   Новый Граница(КонецПериода));
		
	// Получим список счетов для отбора
	ПредопределенныйСписокСчетов = Новый Массив;
	ПредопределенныйСписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеСредстваВКассе);
	ПредопределенныйСписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеСредстваВБанке);
	ПредопределенныйСписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами);
	СписокСчетов = БухгалтерскийУчетСервер.СформироватьМассивСубсчетов(ПредопределенныйСписокСчетов);
	
	// Уберем из иерархии счета по которым не хотим отбирать
	ПредопределенныйСписокИсключаемыхСчетов = Новый Массив;
	ПредопределенныйСписокИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеДокументы);
	ПредопределенныйСписокИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеЭквиваленты);
	СписокСчетов = ОбщегоНазначенияКлиентСервер.РазностьМассивов(СписокСчетов,
		БухгалтерскийУчетСервер.СформироватьМассивСубсчетов(ПредопределенныйСписокИсключаемыхСчетов));
	
	Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотДт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК ПоступлениеТекущийМесяц,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК РасходТекущийМесяц,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоГода И &КонецПериода
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотДт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК ПоступлениеТекущийГод,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоГода И &КонецПериода
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК РасходТекущийГод,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоПрошлогоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотДт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК ПоступлениеПрошлыйМесяц,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период = &НачалоПрошлогоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК РасходПрошлыйМесяц,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоПрошлогоПериода И &КонецПрошлогоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотДт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК ПоступлениеПрошлыйПериод,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА ХозрасчетныйОборотыПоМесяцам.Период МЕЖДУ &НачалоПрошлогоПериода И &КонецПрошлогоМесяца
		|					ТОГДА ХозрасчетныйОборотыПоМесяцам.СуммаОборотКт
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК РасходПрошлыйПериод
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПрошлогоПериода, &КонецПериодаГраница, Месяц, Счет В (&СписокСчетов), , Организация = &Организация, НЕ КорСчет В (&СписокСчетов), ) КАК ХозрасчетныйОборотыПоМесяцам";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПоступлениеТекущийМесяц = 0;
	ПоступлениеПрошлыйМесяц = 0;
	ПоступлениеТекущийГод  = 0;
	ПоступлениеПрошлыйГод  = 0;
	
	РасходТекущийМесяц = 0;
	РасходПрошлыйМесяц = 0;
	РасходТекущийГод  = 0;
	РасходПрошлыйГод  = 0;
	
	Если Результат.Следующий() Тогда
		
		ПоступлениеТекущийМесяц  = Результат.ПоступлениеТекущийМесяц;
		ПоступлениеПрошлыйМесяц  = Результат.ПоступлениеПрошлыйМесяц;
		ПоступлениеТекущийГод    = Результат.ПоступлениеТекущийГод;
		ПоступлениеПрошлыйПериод = Результат.ПоступлениеПрошлыйПериод;
			
		РасходТекущийМесяц  = Результат.РасходТекущийМесяц;
		РасходПрошлыйМесяц  = Результат.РасходПрошлыйМесяц;
		РасходТекущийГод    = Результат.РасходТекущийГод;
		РасходПрошлыйПериод = Результат.РасходПрошлыйПериод;
		
	КонецЕсли;
	
	ПредставлениеТекущегоМесяца            = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоМесяца, КонецПериода);
	ПредставлениеТекущегоМесяцаСНачалаГода = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоГода, КонецПериода);
	ПредставлениеПрошлогоМесяца            = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоПрошлогоМесяца, КонецПрошлогоМесяца);
	ПредставлениеПрошлогоМесяцаСНачалаГода = МониторРуководителя.ПолучитьПредставлениеПериода(НачалоПрошлогоПериода, КонецПрошлогоМесяца);
	
	ТаблицаПоступлениеДенежныхСредств = МониторРуководителя.ТаблицаДанных();
	
	СтрокаТаблицы = ТаблицаПоступлениеДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяца;
	СтрокаТаблицы.Сумма 		= ПоступлениеТекущийМесяц;
	СтрокаТаблицы.Порядок		= 1;
	
	СтрокаТаблицы = ТаблицаПоступлениеДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 		= ПоступлениеТекущийГод;
	СтрокаТаблицы.Порядок		= 2;
	
	СтрокаТаблицы = ТаблицаПоступлениеДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяца;
	СтрокаТаблицы.Сумма 		= ПоступлениеПрошлыйМесяц;
	СтрокаТаблицы.Порядок		= 3;
	
	СтрокаТаблицы = ТаблицаПоступлениеДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 		= ПоступлениеПрошлыйПериод;
	СтрокаТаблицы.Порядок		= 4;
	
	ТаблицаРасходДенежныхСредств = МониторРуководителя.ТаблицаДанных();
	
	СтрокаТаблицы = ТаблицаРасходДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяца;
	СтрокаТаблицы.Сумма 		= РасходТекущийМесяц;
	СтрокаТаблицы.Порядок		= 1;
	
	СтрокаТаблицы = ТаблицаРасходДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеТекущегоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 	    = РасходТекущийГод;
	СтрокаТаблицы.Порядок		= 2;
	
	СтрокаТаблицы = ТаблицаРасходДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяца;
	СтрокаТаблицы.Сумма 		= РасходПрошлыйМесяц;
	СтрокаТаблицы.Порядок		= 3;
	
	СтрокаТаблицы = ТаблицаРасходДенежныхСредств.Добавить();
	СтрокаТаблицы.Представление = ПредставлениеПрошлогоМесяцаСНачалаГода;
	СтрокаТаблицы.Сумма 		= РасходПрошлыйПериод;
	СтрокаТаблицы.Порядок		= 4;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ТаблицаПоступлениеДенежныхСредств", ТаблицаПоступлениеДенежныхСредств);
	СтруктураДанных.Вставить("ТаблицаРасходДенежныхСредств", ТаблицаРасходДенежныхСредств);
	
	Возврат СтруктураДанных;
	
КонецФункции

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Поступление");
	НаборПоказателей.Добавить("Расход");

	Возврат НаборПоказателей;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	Для Каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Вставить("Показатель" + Показатель, Ложь);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#КонецЕсли
