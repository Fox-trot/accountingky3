﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Органинизации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);

	Индекс = СведенияОбОрганизации.Индекс; 
	
	ГородНасПункт = СведенияОбОрганизации.Город;
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
	+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	
	ЭлПочта = СведенияОбОрганизации.Email;
	
	Структура = Новый Структура();
	Структура.Вставить("Индекс", Индекс);
	Структура.Вставить("ЭлПочта", ЭлПочта);
	Структура.Вставить("Телефон", Телефон);
	Структура.Вставить("АдрОбластьГород", АдрОбластьГород);
	Структура.Вставить("АдресОрганизации", АдресОрганизации);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

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

// Функция формирует табличный документ с печатной формой ЕжемесячныйПоСФ
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьЕжемесячногоПоСФ(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ОтчетыПоСоциальномуФонду.Ссылка КАК Ссылка,
		|	ОтчетыПоСоциальномуФонду.Дата КАК Дата,
		|	ОтчетыПоСоциальномуФонду.Организация КАК Организация,
		|	ОтчетыПоСоциальномуФонду.Организация.ОсновнойБанковскийСчет.НомерСчета КАК ОрганизацияОсновнойБанковскийСчетНомерСчета,
		|	ОтчетыПоСоциальномуФонду.Организация.ОсновнойБанковскийСчет.Банк.Наименование КАК ОрганизацияОсновнойБанковскийСчетБанк,
		|	ОтчетыПоСоциальномуФонду.Организация.НаименованиеГКЭД КАК ОрганизацияНаименованиеГКЭД,
		|	ОтчетыПоСоциальномуФонду.Контрагент КАК Контрагент,
		|	ОтчетыПоСоциальномуФонду.ОбязательстваПоСтраховымВзносам КАК СуммаКтПФ_МС_ФОТФ,
		|	ОтчетыПоСоциальномуФонду.ОбязательстваПоПенсионномуФонду КАК СуммаКтГНПФ,
		|	ОтчетыПоСоциальномуФонду.ПереплатаПоСтраховымВзносам КАК СуммаДтПФ_МС_ФОТФ,
		|	ОтчетыПоСоциальномуФонду.ПереплатаПоПенсионномуФонду КАК СуммаДтГНПФ,
		|	ОтчетыПоСоциальномуФонду.ОбязательстваПоСтраховымВзносам + ОтчетыПоСоциальномуФонду.ОбязательстваПоПенсионномуФонду КАК ИтогоОбязательства,
		|	ОтчетыПоСоциальномуФонду.ПереплатаПоСтраховымВзносам + ОтчетыПоСоциальномуФонду.ПереплатаПоПенсионномуФонду КАК ИтогоПереплата,
		|	ОтчетыПоСоциальномуФонду.СведенияОЗанятостиИЗаработнойПлате.(
		|		НомерСтроки КАК НомерСтроки,
		|		Физлицо КАК ФизЛицо,
		|		Физлицо.ИНН КАК ИНН,
		|		ДатаНачалаРаботы КАК ДатаНачала,
		|		ДатаОкончанияРаботы КАК ДатаОкончания,
		|		Дней КАК ДнейНорма,
		|		ФактическиДней КАК ДнейФакт,
		|		ФондОплатыТруда КАК ФОТ,
		|		ДополнительныйФондОплатыТруда КАК ДопФОТ,
		|		НачисленыеСтраховыеВзносы КАК СтраховыеВзносы,
		|		НачсиленыеВзносыПоНПФ КАК ГНПФР,
		|		Категория КАК Категория
		|	) КАК СведенияОЗанятостиИЗаработнойПлате,
		|	ОтчетыПоСоциальномуФонду.ФондОплатыТрудаПоКатегориям.(
		|		Категория КАК Категория,
		|		Численость КАК Численность,
		|		ФОТБолее КАК ФОТБольше40Процентов,
		|		ФОТМенее КАК ФОТМеньше40Процентов,
		|		ДопФОТ КАК ДопФОТ,
		|		Итого КАК Всего
		|	) КАК ФондОплатыТрудаПоКатегориям
		|ИЗ
		|	Документ.ОтчетыПоСоциальномуФонду КАК ОтчетыПоСоциальномуФонду
		|ГДЕ
		|	ОтчетыПоСоциальномуФонду.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ОтчетыПоСоциальномуФонду_ЕжемесячныйОтчетПоСФ";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОтчетыПоСоциальномуФонду.ПФ_MXL_ЕжемесячныйОтчетПоСФ");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Дата = Шапка.Дата;
		Организация = Шапка.Организация;
		
		КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
		ДанныеПечати = Новый Структура; 
		ДанныеПечати.Вставить("Плательщик",  Организация.НаименованиеПолное);
		ДанныеПечати.Вставить("ИНН", 		 Организация.ИНН);
		ДанныеПечати.Вставить("РегНомер", 	 Организация.РегНомерСоцФонда);
		ДанныеПечати.Вставить("ОКПО", 		 Организация.КодПоОКПО);
		ДанныеПечати.Вставить("ОтделениеСФ", Шапка.Контрагент);
		ДанныеПечати.Вставить("Дата", 		 Формат(Дата,"ДФ='ММММ гггг'"));
		ДанныеПечати.Вставить("ДатаДок", 	 Нрег(Формат(ДобавитьМесяц(Дата, 1),"ДФ='ММММ гггг'")));
		ДанныеПечати.Вставить("Адрес", 		 КонтактныеДанные.АдресОрганизации);
		ДанныеПечати.Вставить("Телефон", 	 КонтактныеДанные.Телефон);
		
		ДанныеПечати.Вставить("НаименованиеБанка", Шапка.ОрганизацияОсновнойБанковскийСчетБанк);
		ДанныеПечати.Вставить("БанковскийСчет", Шапка.ОрганизацияОсновнойБанковскийСчетНомерСчета);
		ДанныеПечати.Вставить("ВидДеятельности", Шапка.ОрганизацияНаименованиеГКЭД);
		
		Руководители = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.Дата);
		ДанныеПечати.Вставить("Руководитель", Руководители.Руководитель);
		ДанныеПечати.Вставить("ГлавныйБухгалтер", Руководители.ГлавныйБухгалтер);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
		ТабличныйДокумент.Вывести(ОбластьМакета);	
		
		ВыборкаСведенийОЗанятостиИЗП = Шапка.СведенияОЗанятостиИЗаработнойПлате.Выбрать();
		
		ДанныеПечатиИтоги = Новый Структура; 
		ДанныеПечатиИтоги.Вставить("ФОТ",0);
		ДанныеПечатиИтоги.Вставить("ДопФОТ",0);
		ДанныеПечатиИтоги.Вставить("СтраховыеВзносы",0);
		ДанныеПечатиИтоги.Вставить("ГНПФР",0);
		ДанныеПечатиИтоги.Вставить("Численность",0);
		ДанныеПечатиИтоги.Вставить("ФОТБольше40Процентов",0);
		ДанныеПечатиИтоги.Вставить("ФОТМеньше40Процентов",0);
		ДанныеПечатиИтоги.Вставить("Всего",0);

		Пока ВыборкаСведенийОЗанятостиИЗП.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ДеталиСведенияОЗП");
			ОбластьМакета.Параметры.Заполнить(ВыборкаСведенийОЗанятостиИЗП);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечатиИтоги.ФОТ 				= ДанныеПечатиИтоги.ФОТ 			+ ВыборкаСведенийОЗанятостиИЗП.ФОТ;
			ДанныеПечатиИтоги.ДопФОТ 			= ДанныеПечатиИтоги.ДопФОТ 			+ ВыборкаСведенийОЗанятостиИЗП.ДопФОТ;
			ДанныеПечатиИтоги.СтраховыеВзносы 	= ДанныеПечатиИтоги.СтраховыеВзносы + ВыборкаСведенийОЗанятостиИЗП.СтраховыеВзносы;
			ДанныеПечатиИтоги.ГНПФР 			= ДанныеПечатиИтоги.ГНПФР 			+ ВыборкаСведенийОЗанятостиИЗП.ГНПФР;
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоСведенияОЗП");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаФОТПоКатегориям");
		ТабличныйДокумент.Вывести(ОбластьМакета);
						
		ВыборкаФондОплатыТруда = Шапка.ФондОплатыТрудаПоКатегориям.Выбрать();
		
		// Обнуляется значение "ДопФОТ" для нового заполнения.
		ДанныеПечатиИтоги.ДопФОТ = 0;
		
		Пока ВыборкаФондОплатыТруда.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ДеталиФОТПоКатегориям");
			ОбластьМакета.Параметры.Заполнить(ВыборкаФондОплатыТруда);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ДанныеПечатиИтоги.Численность 		 	= ДанныеПечатиИтоги.Численность 		 + ВыборкаФондОплатыТруда.Численность;
			ДанныеПечатиИтоги.ФОТБольше40Процентов 	= ДанныеПечатиИтоги.ФОТБольше40Процентов + ВыборкаФондОплатыТруда.ФОТБольше40Процентов;
			ДанныеПечатиИтоги.ФОТМеньше40Процентов	= ДанныеПечатиИтоги.ФОТМеньше40Процентов + ВыборкаФондОплатыТруда.ФОТМеньше40Процентов;
			ДанныеПечатиИтоги.ДопФОТ 				= ДанныеПечатиИтоги.ДопФОТ 				 + ВыборкаФондОплатыТруда.ДопФОТ;
			ДанныеПечатиИтоги.Всего 				= ДанныеПечатиИтоги.Всего 				 + ВыборкаФондОплатыТруда.Всего;
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоФОТПоКатегориям");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиИтоги);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Коды");	
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Обязательства");	
		ОбластьМакета.Параметры.Заполнить(Шапка);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");	
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);		
		ТабличныйДокумент.Вывести(ОбластьМакета);		
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
		
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьЕжемесячногоПоСФ()

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
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЕжемесячныйОтчетСФ") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЕжемесячныйОтчетСФ", НСтр("ru = 'Печать ежемесячного отчета по СФ'"), ПечатьЕжемесячногоПоСФ(МассивОбъектов, ОбъектыПечати),,
		"Документ.ОтчетыПоСоциальномуФонду.ПФ_MXL_ЕжемесячныйОтчетПоСФ");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЕжемесячныйОтчетСФ";
	КомандаПечати.Представление = НСтр("ru = 'Печать ежемесячного отчета по СФ'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
			
КонецПроцедуры

#КонецОбласти

#КонецЕсли