﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ИнтерфейсПечати

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	Перем Ошибки;
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОсновныеСредства_КарточкаОС";
	ПервыйДокумент = Истина;
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 		
		              
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		Если ИмяМакета = "КарточкаОС" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ОсновныеСредства.КарточкаОС");
			
			ОбластьМакета = Макет.ПолучитьОбласть("Область");
			
			Ссылка = ТекущийДокумент.Ссылка;
			ДатаСведений  = ТекущаяДатаСеанса(); 	
			
			// Данные для заполнения закладки Бухгалтерский учет
			ВыборкаЗаписей = РегистрыСведений.ПараметрыУчетаОС.СрезПоследних(ДатаСведений,Новый Структура("ОсновноеСредство",Ссылка));

			ТекОрганизация = ?(ВыборкаЗаписей.Количество() > 0,ВыборкаЗаписей[0].Организация,0);   	
			
			Организация    = ТекОрганизация;  				
			
			//Последние сведения об ОС
			Запрос = Новый Запрос();
			Запрос.УстановитьПараметр("Организация",      Организация);
			Запрос.УстановитьПараметр("ДатаСведений",     ДатаСведений);
			Запрос.УстановитьПараметр("ОсновноеСредство", Ссылка);
			Запрос.УстановитьПараметр("СубконтоОС", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних.СчетУчета КАК СчетУчета,
			|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.СрокСлужбы КАК СрокСлужбы,
			|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Подразделение КАК Подразделение,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.Организация КАК Организация,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство.Изготовитель КАК ИзготовительОС,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство.НомерПаспорта КАК ОсновноеСредствоНомерПаспорта,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство.ЗаводскойНомер КАК ОсновноеСредствоЗаводскойНомер,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ИнвентарныйНомер КАК ИнвентарныйНомер,
			|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ КАК МОЛ,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
			|	ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость - ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты_Амортизация.СуммаКонечныйОстатокКт, 0) КАК ОстаточнаяСтоимость,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.Период КАК ДатаКапитализации,
			|	ПараметрыУчетаОССрезПервых.СрокСлужбы КАК ПервоначальныйСрокСлужбы,
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.СрокСлужбы - ПараметрыУчетаОССрезПервых.СрокСлужбы КАК СрокУвеличенияИспользования
			|ИЗ
			|	РегистрСведений.ПараметрыУчетаОС.СрезПоследних(
			|			&ДатаСведений,
			|			Организация = &Организация
			|				И ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПоследних(
			|				&ДатаСведений,
			|				Организация = &Организация
			|					И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних
			|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = ПараметрыАмортизацииОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПоследних(
			|				&ДатаСведений,
			|				Организация = &Организация
			|					И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних
			|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = СчетаБухгалтерскогоУчетаОсновныхСредствСрезПоследних.ОсновноеСредство
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(
			|				&ДатаСведений,
			|				Организация = &Организация
			|					И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
			|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(, &ДатаСведений, , , , ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства), ) КАК ХозрасчетныйОстаткиИОбороты_Амортизация
			|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = ХозрасчетныйОстаткиИОбороты_Амортизация.Субконто1
			|			И ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.СчетУчета.ПарныйСчет = ХозрасчетныйОстаткиИОбороты_Амортизация.Счет
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПервых КАК ПараметрыУчетаОССрезПервых
			|		ПО ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.ОсновноеСредство = ПараметрыУчетаОССрезПервых.ОсновноеСредство
			|ГДЕ
			|	ПервоначальныеСведенияОбОсновныхСредствахОрганизацийСрезПоследних.Организация = &Организация";
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			
			//документы принятия к учету и выбытия ОС
			Запрос2 = Новый Запрос;
			Запрос2.Текст = 
			"ВЫБРАТЬ
			|	СостоянияОС.ОсновноеСредство,
			|	СостоянияОС.Состояние,
			|	СостоянияОС.Период КАК ДатаСостояния,
			|	СостоянияОС.Регистратор
			|ИЗ
			|	РегистрСведений.СостоянияОС КАК СостоянияОС
			|ГДЕ
			|	СостоянияОС.Организация = &Организация
			|	И СостоянияОС.ОсновноеСредство = &ОсновноеСредство";
			Запрос2.УстановитьПараметр("Организация", Организация);
			Запрос2.УстановитьПараметр("ОсновноеСредство", Ссылка);
			Запрос2.УстановитьПараметр("ДатаСведений", ДатаСведений);
			Выборка2 = Запрос2.Выполнить().Выбрать();
			
			// Основная область
			ТекущаяСтоимость =  0;
			СуммаНачисленнойАмортизации = 0;
			
			ОбластьМакета.Параметры.ПервоначальнаяСтоимость = 0;
			
			Пока Выборка2.Следующий() Цикл
				Если Выборка2.Состояние   = Перечисления.ВидыСостоянийОС.ПринятоКУчету Тогда
					ОбластьМакета.Параметры.ДатаПриобретения = Формат(Выборка2.ДатаСостояния,"ДЛФ=D");//именно поступления
				ИначеЕсли Выборка2.Состояние   = Перечисления.ВидыСостоянийОС.СнятоСУчета Тогда
					ОбластьМакета.Параметры.ДатаВыбытия = Формат(Выборка2.ДатаСостояния,"ДЛФ=D");//именно выбытия
				КонецЕсли;
			КонецЦикла;
			
			ОбластьМакета.Параметры.ОсновноеСредство = Ссылка;
			ОбластьМакета.Параметры.Местонахождение = Выборка.Подразделение;
			//ОбластьМакета.Параметры.КодОрганизации = Выборка.Организация.Код;
			ОбластьМакета.Параметры.Организация = Выборка.Организация;
			ОбластьМакета.Параметры.БалансоваяСтоимость = Выборка.ПервоначальнаяСтоимость;
			ОбластьМакета.Параметры.ОстаточнаяСтоимость = Выборка.ОстаточнаяСтоимость;
			ОбластьМакета.Параметры.ДатаКапитализации 	= Формат(Выборка.ДатаКапитализации,"ДЛФ=D");
			ОбластьМакета.Параметры.ССПересмотрен 		= Выборка.СрокУвеличенияИспользования;
			ОбластьМакета.Параметры.СрокСлужбы 			= Выборка.СрокСлужбы;
			ОбластьМакета.Параметры.ПервоначальныйСрокСлужбы = Выборка.ПервоначальныйСрокСлужбы;
			
			ОбластьМакета.Параметры.Группа = ТекущийДокумент.Родитель;
			//ОбластьМакета.Параметры.МОЛ = Выборка.МОЛ;
			
			ФормСтрока = "Л = ru_RU; ДП = Истина";
			ПарПредмета="сом,сома,сом,м,тыйын,тыйын,тыйын,м,2";
		
			ОбластьМакета.Параметры.ПСПрописью = ЧислоПрописью(?(ЗначениеЗаполнено(ОбластьМакета.Параметры.ПервоначальнаяСтоимость), ОбластьМакета.Параметры.ПервоначальнаяСтоимость, 0), ФормСтрока, ПарПредмета); 			                                   		
		
			ОбластьМакета.Параметры.ЗавНомерПредмета = ТекущийДокумент.ЗаводскойНомер;
			ОбластьМакета.Параметры.Примечание = ТекущийДокумент.Комментарий; 			
			
			ДатаПринятияКучету = Неопределено;
			ВыборкаЗаписей = РегистрыСведений.ПараметрыУчетаОС.ПолучитьПоследнее(ДатаСведений,Новый Структура("ОсновноеСредство",Ссылка));
			СрокСлужбы = ?(ВыборкаЗаписей.Количество() > 0, ВыборкаЗаписей.СрокСлужбы, 0);
				
			//для расчета накопленной стоимости амортиции
			ВидСубконтоОС = Новый Массив();
			ВидСубконтоОС.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
			
			ВыборкаЗаписей = РегистрыСведений.ПараметрыУчетаОС.СрезПоследних(ДатаСведений,Новый Структура("ОсновноеСредство",Ссылка));
			ТекОрганизация = ?(ВыборкаЗаписей.Количество() > 0,ВыборкаЗаписей[0].Организация,Справочники.Организации.ПустаяСсылка());
			
			ВыборкаЗаписей = РегистрыСведений.ПараметрыУчетаОС.ПолучитьПоследнее(ДатаСведений,Новый Структура("ОсновноеСредство",Ссылка));
			СчетНачисленияАмортизации = ?(ВыборкаЗаписей.Количество() > 0, ВыборкаЗаписей.СчетУчета.ПарныйСчет,0);
			//считаем
			ВыборкаЗаписей = РегистрыБухгалтерии.Хозрасчетный.Остатки(ДатаСведений,ВидСубконтоОС,Новый Структура("Субконто1,Организация,Счет",Ссылка,ТекОрганизация,СчетНачисленияАмортизации));
			//выводим
			ОбластьМакета.Параметры.НакопленнаяАмортизация = ?(ВыборкаЗаписей.Количество() > 0,ВыборкаЗаписей[0].СуммаОстатокКт,0);
	
			ТабличныйДокумент.Вывести(ОбластьМакета); 			
			
		КонецЕсли;
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
	Возврат ТабличныйДокумент;
КонецФункции // ПечатнаяФорма()

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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаОС") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"КарточкаОС",
		НСтр("ru = 'Карточка ОС'"),
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "КарточкаОС"));
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КарточкаОС";
	КомандаПечати.Представление = НСтр("ru = 'Карточка ОС'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1; 
КонецПроцедуры

#КонецОбласти

#КонецЕсли
