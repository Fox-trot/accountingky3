﻿#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СотрудникиФормыВнутренний.ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьДублиИНН(ИНН,Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка,
	|	ФизическиеЛица.Наименование
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	НЕ ФизическиеЛица.ПометкаУдаления
	|	И НЕ ФизическиеЛица.ИНН = """"
	|	И ФизическиеЛица.ИНН = &ИНН
	|	И ФизическиеЛица.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("ИНН",	ИНН);	
	Запрос.УстановитьПараметр("Ссылка",	Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДублиИНН = НСтр("ru = 'Дублирование ИНН!
	| Введенный ИНН уже используется у:'") + Символы.ПС;
		
	Возврат ВыборкаДетальныеЗаписи;	
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсПечати

// Процедура формирования макета печати
//
Функция СформироватьПомощникРаботыФаксимильнойПечати(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	Макет				= УправлениеПечатью.МакетПечатнойФормы("Справочник.ФизическиеЛица." + ИмяМакета);
	
	Для каждого ОбъектПечати Из МассивОбъектов Цикл 
	
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПоляКЗаполнению"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Линия"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Схема"));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, ОбъектПечати);
	
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // СформироватьПомощникРаботыФаксимильнойПечати()

Функция НапечататьКарточку(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	Перем Ошибки;
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ФизическиеЛица_ЛичнаяКарточка";
	ПервыйДокумент = Истина;
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 		
		              
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
		Макет 	= УправлениеПечатью.МакетПечатнойФормы("Справочник.ФизическиеЛица.ПФ_XML_ЛичнаяКарточка");
		ФизЛицо = ТекущийДокумент.Ссылка;
		Дата   	= ТекущаяДатаСеанса(); 	
		
		ВыборкаЗаписей = РегистрыСведений.Сотрудники.СрезПоследних(Дата, Новый Структура("ФизЛицо", ФизЛицо));

		Организация = ?(ВыборкаЗаписей.Количество() > 0, ВыборкаЗаписей[0].Организация, Справочники.Организации.ПустаяСсылка());   	
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Период", Дата);
		Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ГражданствоФизическихЛицСрезПоследних.Страна КАК Страна
			|ИЗ
			|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(&Период, ФизЛицо = &ФизЛицо) КАК ГражданствоФизическихЛицСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ФИОФизическихЛицСрезПоследних.Фамилия КАК Фамилия,
			|	ФИОФизическихЛицСрезПоследних.Имя КАК Имя,
			|	ФИОФизическихЛицСрезПоследних.Отчество КАК Отчество
			|ИЗ
			|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&Период, ФизЛицо = &ФизЛицо) КАК ФИОФизическихЛицСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЗнаниеЯзыковФизическихЛиц.Язык КАК Язык,
			|	ЗнаниеЯзыковФизическихЛиц.СтепеньЗнанияЯзыка КАК СтепеньЗнанияЯзыка
			|ИЗ
			|	РегистрСведений.ЗнаниеЯзыковФизическихЛиц КАК ЗнаниеЯзыковФизическихЛиц
			|ГДЕ
			|	ЗнаниеЯзыковФизическихЛиц.ФизЛицо = &ФизЛицо
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ОбразованиеФизическихЛиц.Диплом КАК ДипломОбразовательногоУчреждения,
			|	ОбразованиеФизическихЛиц.ВидОбразования КАК ВидОбразования,
			|	ОбразованиеФизическихЛиц.УчебноеЗаведение КАК НаименованиеОбразовательногоУчреждения,
			|	ОбразованиеФизическихЛиц.ГодОкончания КАК ГодОкончанияОбразовательногоУчреждения,
			|	ОбразованиеФизическихЛиц.Квалификация КАК КвалификацияОбразовательногоУчреждения,
			|	ОбразованиеФизическихЛиц.Специальность КАК СпециальностьОбразовательногоУчреждения
			|ИЗ
			|	РегистрСведений.ОбразованиеФизическихЛиц КАК ОбразованиеФизическихЛиц
			|ГДЕ
			|	ОбразованиеФизическихЛиц.ФизЛицо = &ФизЛицо
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СостоянияВБракеФизическихЛицСрезПоследних.СостояниеВБраке КАК СостояниеВБраке
			|ИЗ
			|	РегистрСведений.СостоянияВБракеФизическихЛиц.СрезПоследних(&Период, ФизЛицо = &ФизЛицо) КАК СостоянияВБракеФизическихЛицСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СоставыСемейФизическихЛиц.ФИО КАК ФИО_Семья,
			|	СоставыСемейФизическихЛиц.СтепеньРодства КАК СтепеньРодства,
			|	СоставыСемейФизическихЛиц.ДатаРождения КАК ГодРождения_Семья
			|ИЗ
			|	РегистрСведений.СоставыСемейФизическихЛиц КАК СоставыСемейФизическихЛиц
			|ГДЕ
			|	СоставыСемейФизическихЛиц.ФизЛицо = &ФизЛицо
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДокументыФизическихЛицСрезПоследних.Серия КАК Серия,
			|	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
			|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи КАК ДатаВыдачи,
			|	ДокументыФизическихЛицСрезПоследних.КемВыдан КАК КемВыдан
			|ИЗ
			|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
			|			&Период,
			|			ФизЛицо = &ФизЛицо
			|				И ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Паспорт)) КАК ДокументыФизическихЛицСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВоинскийУчетФизическихЛицСрезПоследних.ОтношениеКВоинскомуУчету КАК ВоинскийУчет,
			|	ВоинскийУчетФизическихЛицСрезПоследних.Звание КАК ВоинскоеЗвание,
			|	ВоинскийУчетФизическихЛицСрезПоследних.Состав КАК Состав_ВоинскийУчет,
			|	ВоинскийУчетФизическихЛицСрезПоследних.ВУС КАК ВУС,
			|	ВоинскийУчетФизическихЛицСрезПоследних.Годность КАК КатегорияГодности,
			|	ВоинскийУчетФизическихЛицСрезПоследних.Военкомат КАК ВоенныйКомиссариат,
			|	ВоинскийУчетФизическихЛицСрезПоследних.Спецучет КАК Спецучет
			|ИЗ
			|	РегистрСведений.ВоинскийУчетФизическихЛиц.СрезПоследних(&Период, ФизЛицо = &ФизЛицо) КАК ВоинскийУчетФизическихЛицСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Сотрудники.Период КАК ДатаРаботы,
			|	Сотрудники.Подразделение КАК ПодразделениеРаботы,
			|	Сотрудники.Должность КАК ДолжностьРаботы,
			|	Сотрудники.Регистратор.Размер КАК Оклад
			|ИЗ
			|	РегистрСведений.Сотрудники КАК Сотрудники
			|ГДЕ
			|	Сотрудники.ФизЛицо = &ФизЛицо
			|	И Сотрудники.Период <= &Период
			|	И (Сотрудники.Регистратор ССЫЛКА Документ.ПриемНаРаботу
			|	ИЛИ Сотрудники.Регистратор ССЫЛКА Документ.КадровоеПеремещение)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ПоощренияИВзыскания.НомерПриказа КАК НомерДокументаПереподготовки,
			|	ПоощренияИВзыскания.ДатаПриказа КАК ДатаДокументаПереподготовки,
			|	ПоощренияИВзыскания.Награда КАК НаименованиеНаграды,
			|	ПоощренияИВзыскания.НаименованиеПриказа КАК НаименованиеДокументаПереподготовки
			|ИЗ
			|	РегистрСведений.ПоощренияИВзыскания КАК ПоощренияИВзыскания
			|ГДЕ
			|	ПоощренияИВзыскания.ФизЛицо = &ФизЛицо
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Отпуск.МетодРасчета.ВидОтпуска КАК ВидОтпуска,
			|	Отпуск.Дней КАК ДнейОтпуска,
			|	Отпуск.ДатаНачала КАК НачалоОтпуска,
			|	Отпуск.ДатаОкончания КАК ОкончаниеОтпуска
			|ИЗ
			|	Документ.Отпуск КАК Отпуск
			|ГДЕ
			|	Отпуск.ФизЛицо = &ФизЛицо
			|	И Отпуск.Дата <= &Период
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Увольнение.ОснованиеУвольнения КАК ОснованиеУвольнения,
			|	Увольнение.ДатаУвольнения КАК ДатаУвольнения,
			|	Увольнение.Номер КАК НомерУвольнения
			|ИЗ
			|	Документ.Увольнение КАК Увольнение
			|ГДЕ
			|	Увольнение.ФизЛицо = &ФизЛицо
			|	И Увольнение.Дата <= &Период";
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		// Общие данные
		ДанныеПечати = Новый Структура();
		ДанныеПечати.Вставить("Организация",				
				?(Организация.НаименованиеПолное <> "", Организация.НаименованиеПолное, Организация.Наименование)); 
		ДанныеПечати.Вставить("ДатаСоставления", 			Дата);
		ДанныеПечати.Вставить("ТабельныйНомер", 			ФизЛицо.Код);
		ДанныеПечати.Вставить("ИдентификационныйНомерНал", 	ФизЛицо.ИНН);
		ДанныеПечати.Вставить("Пол", 						ФизЛицо.Пол);
		ДанныеПечати.Вставить("ДатаРождения", 				ФизЛицо.ДатаРождения);
		ДанныеПечати.Вставить("МестоРождения", 				ОбщегоНазначенияБПКлиентСервер.ПредставлениеМестаРождения(ФизЛицо.МестоРождения));
		
		// Гражданство
		ВыборкаГражданство = МассивРезультатов[0].Выбрать();
		
		Если ВыборкаГражданство.Следующий() Тогда	
			ДанныеПечати.Вставить("Гражданство", ВыборкаГражданство.Страна);				
		КонецЕсли;	
		
		// ФИО
		ВыборкаФИО = МассивРезультатов[1].Выбрать();
		
		Если ВыборкаФИО.Следующий() Тогда	
			ДанныеПечати.Вставить("Фамилия", 	ВыборкаФИО.Фамилия);
			ДанныеПечати.Вставить("Имя", 		ВыборкаФИО.Имя);
			ДанныеПечати.Вставить("Отчество", 	ВыборкаФИО.Отчество);
		КонецЕсли;
		
		// Знание языков
		ВыборкаЯзыки 		= МассивРезультатов[2].Выбрать();
		ЯзыкиИСтепеньЗнания = "";
		ПерваяСтрока 		= Истина;
		
		Пока ВыборкаЯзыки.Следующий() Цикл
			
			Если ПерваяСтрока Тогда
				ЯзыкиИСтепеньЗнания = ЯзыкиИСтепеньЗнания + ВыборкаЯзыки.Язык + " - " + ВыборкаЯзыки.СтепеньЗнанияЯзыка;
			Иначе
				ЯзыкиИСтепеньЗнания = ЯзыкиИСтепеньЗнания + "; " + ВыборкаЯзыки.Язык + " - " + ВыборкаЯзыки.СтепеньЗнанияЯзыка;
			КонецЕсли;
			
			ПерваяСтрока = Ложь;
		КонецЦикла;	
		
		ДанныеПечати.Вставить("ИностранныеЯзыки", ЯзыкиИСтепеньЗнания);
		
		// Образование
		ТаблицаОбразование 		= МассивРезультатов[3].Выгрузить();		
		МассивВидовОбразования 	= ТаблицаОбразование.ВыгрузитьКолонку("ВидОбразования");
		ВидыОбразования 		= "";
		ПерваяСтрока 			= Истина;
		
		Для Каждого СтрокаМассива Из МассивВидовОбразования Цикл
			
			Если ПерваяСтрока Тогда
				ВидыОбразования = ВидыОбразования + СтрокаМассива;
			Иначе
				ВидыОбразования = ВидыОбразования + "; " + СтрокаМассива;
			КонецЕсли;
			
			ПерваяСтрока = Ложь;		
		КонецЦикла;	
		
		ДанныеПечати.Вставить("Образование", ВидыОбразования);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Для Каждого СтрокаТаблицы Из ТаблицаОбразование Цикл	
			ОбластьМакета = Макет.ПолучитьОбласть("ОбразовательныеУчреждения");
			ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;	
		
		Если ТаблицаОбразование.Количество() = 0 Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ОбразовательныеУчреждения");
			ТабличныйДокумент.Вывести(ОбластьМакета);	
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПослевузовскоеОбразование");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Стаж и состояние в браке
		СведенияОСтаже 			= ПроведениеРасчетовПоЗарплатеСервер.СведенияОСтажеСотрудника(Дата, Организация, ФизЛицо);
		ВыборкаСостоянияВБраке 	= МассивРезультатов[4].Выбрать();
		
		ДанныеПечати.Вставить("ДнейОбщегоСтажа", 	СведенияОСтаже.Дней);
		ДанныеПечати.Вставить("МесяцевОбщегоСтажа", СведенияОСтаже.Месяцев);
		ДанныеПечати.Вставить("ЛетОбщегоСтажа", 	СведенияОСтаже.Лет);
		
		Если ВыборкаСостоянияВБраке.Следующий() Тогда
			ДанныеПечати.Вставить("СостояниеВБраке", ВыборкаСостоянияВБраке.СостояниеВБраке);			
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("СтажИБрак");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Состав семьи
		ОбластьМакета = Макет.ПолучитьОбласть("СоставСемьиШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ВыборкаСоставСемьи = МассивРезультатов[5].Выбрать();
		
		Если ВыборкаСоставСемьи.Количество() = 0 Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("СоставСемьиСтрока");
			ТабличныйДокумент.Вывести(ОбластьМакета);			
		КонецЕсли;	
		
		Пока ВыборкаСоставСемьи.Следующий() Цикл	
			ОбластьМакета = Макет.ПолучитьОбласть("СоставСемьиСтрока");
			ОбластьМакета.Параметры.Заполнить(ВыборкаСоставСемьи);
			ТабличныйДокумент.Вывести(ОбластьМакета);	
		КонецЦикла;	
		
		// Паспорт и адреса
		ВыборкаПаспорт 	= МассивРезультатов[6].Выбрать();
		ДанныеПаспорта 	= "";
		ПаспортВыдан	= "";
		
		Если ВыборкаПаспорт.Следующий() Тогда
			ПаспортВыдан 	= ВыборкаПаспорт.КемВыдан;
			ДанныеПаспорта 	= СтрШаблон(НСтр("ru = 'серия %1 №%2 %3'"), 
									ВыборкаПаспорт.Серия, ВыборкаПаспорт.Номер, Формат(ВыборкаПаспорт.ДатаВыдачи, "ДЛФ=D"));
		КонецЕсли;	
		
		ДанныеПечати.Вставить("Паспорт", 				ДанныеПаспорта);
		ДанныеПечати.Вставить("ОрганВыдавшийПаспорт", 	ПаспортВыдан);
		                                                         
		СоответствиеАдреса = Новый Соответствие;
		СоответствиеАдреса.Вставить("Страна",			"");
		СоответствиеАдреса.Вставить("Индекс",			"");
		СоответствиеАдреса.Вставить("Регион",			"");
		СоответствиеАдреса.Вставить("Район",			"");
		СоответствиеАдреса.Вставить("Город",			"");
		СоответствиеАдреса.Вставить("НаселенныйПункт", 	"");
		СоответствиеАдреса.Вставить("Улица",			"");
		СоответствиеАдреса.Вставить("Дом",				"");
		СоответствиеАдреса.Вставить("Корпус",			"");
		СоответствиеАдреса.Вставить("Квартира",			"");
		
		// Адрес по прописке.
		Данные = Новый Структура("Тип, Вид", Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
		Результат = ФизЛицо.КонтактнаяИнформация.НайтиСтроки(Данные);

		Если Результат.Количество() > 0 Тогда
			ЗначениеКонтактнаяИнформация = Результат[0].Значение;
		Иначе
			ЗначениеКонтактнаяИнформация = ",,,,,,,,,";
		КонецЕсли;
		
		БухгалтерскийУчетВызовСервераПовтИсп.СформироватьАдрес(ЗначениеКонтактнаяИнформация, СоответствиеАдреса); 
		                                                                               
		ДанныеПечати.Вставить("ПочтовыйИндексПоПаспорту", СоответствиеАдреса["Индекс"]);
		
		ГородНасПункт = ?(СоответствиеАдреса["Город"] = "", СоответствиеАдреса["НаселенныйПункт"], СоответствиеАдреса["Город"]);
		
		ДанныеПечати.Вставить("АдресПоПаспорту", "" 
			+ ?(СоответствиеАдреса["Регион"] = "", "", СоответствиеАдреса["Регион"] + ",")
			+ ?(СоответствиеАдреса["Район"] = "","", " " + СоответствиеАдреса["Район"] + ",") 
			+ ?(ГородНасПункт = "", "", " " + ГородНасПункт + ",")
			+ ?(СоответствиеАдреса["Улица"] = "","", " " + СоответствиеАдреса["Улица"] + ",")
			+ ?(СоответствиеАдреса["Дом"] = "","", " д." + СоответствиеАдреса["Дом"] + ",")
			+ ?(СоответствиеАдреса["Корпус"] = "","", " кор." + СоответствиеАдреса["Корпус"] + ",")
			+ ?(СоответствиеАдреса["Квартира"] = "","", " кв." + СоответствиеАдреса["Квартира"]));
			
		// Адрес проживания.
		Данные = Новый Структура("Тип, Вид", Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица);
		Результат = ФизЛицо.КонтактнаяИнформация.НайтиСтроки(Данные);
		
		Если Результат.Количество() > 0 Тогда
			ЗначениеКонтактнаяИнформация = Результат[0].Значение;
		Иначе
			ЗначениеКонтактнаяИнформация = ",,,,,,,,,";
		КонецЕсли;
		
		БухгалтерскийУчетВызовСервераПовтИсп.СформироватьАдрес(ЗначениеКонтактнаяИнформация, СоответствиеАдреса); 
		                                                                               
		ДанныеПечати.Вставить("ПочтовыйИндексФактический", СоответствиеАдреса["Индекс"]);
		
		ГородНасПункт = ?(СоответствиеАдреса["Город"] = "", СоответствиеАдреса["НаселенныйПункт"], СоответствиеАдреса["Город"]);
		
		ДанныеПечати.Вставить("АдресФактический", "" 
			+ ?(СоответствиеАдреса["Регион"] = "", "", СоответствиеАдреса["Регион"] + ",")
			+ ?(СоответствиеАдреса["Район"] = "","", " " + СоответствиеАдреса["Район"] + ",") 
			+ ?(ГородНасПункт = "", "", " " + ГородНасПункт + ",")
			+ ?(СоответствиеАдреса["Улица"] = "","", " " + СоответствиеАдреса["Улица"] + ",")
			+ ?(СоответствиеАдреса["Дом"] = "","", " д." + СоответствиеАдреса["Дом"] + ",")
			+ ?(СоответствиеАдреса["Корпус"] = "","", " кор." + СоответствиеАдреса["Корпус"] + ",")
			+ ?(СоответствиеАдреса["Квартира"] = "","", " кв." + СоответствиеАдреса["Квартира"]));
		
		ДомашнийТелефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ФизЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица, Дата);
		ДанныеПечати.Вставить("Телефон", ДомашнийТелефон);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПаспортИАдрес");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Воинский учет
		ВыборкаВоинскийУчет = МассивРезультатов[7].Выбрать();
		
		Если ВыборкаВоинскийУчет.Следующий() Тогда
			ДанныеПечати.Вставить("ВоинскоеЗвание", ВыборкаВоинскийУчет.ВоинскоеЗвание);
			ДанныеПечати.Вставить("Состав_ВоинскийУчет", ВыборкаВоинскийУчет.Состав_ВоинскийУчет);
			ДанныеПечати.Вставить("ВУС", ВыборкаВоинскийУчет.ВУС);
			ДанныеПечати.Вставить("КатегорияГодности", ВыборкаВоинскийУчет.КатегорияГодности);
			ДанныеПечати.Вставить("ВоенныйКомиссариат", ВыборкаВоинскийУчет.ВоенныйКомиссариат);
			ДанныеПечати.Вставить("ВоинскийУчет", ВыборкаВоинскийУчет.ВоинскийУчет);
			
			Если ВыборкаВоинскийУчет.Спецучет Тогда
				ДанныеПечати.Вставить("СпецВоинскийУчет", "Спецучет");
			КонецЕсли;
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ВоинскийУчет");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Кадровые документы
		ВыборкаКадровыеДокументы = МассивРезультатов[8].Выбрать();
		
		ОбластьМакета = Макет.ПолучитьОбласть("КадровыеДокументыШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ВыборкаКадровыеДокументы.Количество() = 0 Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("КадровыеДокументыСтрока");
			ТабличныйДокумент.Вывести(ОбластьМакета);	
		КонецЕсли;	
		
		Пока ВыборкаКадровыеДокументы.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("КадровыеДокументыСтрока");
			ОбластьМакета.Параметры.Заполнить(ВыборкаКадровыеДокументы);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;	
		
		// Аттестация
		ОбластьМакета = Макет.ПолучитьОбласть("Аттестация");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Повышение квалификации
		ОбластьМакета = Макет.ПолучитьОбласть("ПовышениеКвалификации");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Профессиональная переподготовка
		ОбластьМакета = Макет.ПолучитьОбласть("ПрофессиональнаяПереподготовка");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		// Поощрения и награды
		ВыборкаПоощренияИНаграды = МассивРезультатов[9].Выбрать();
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПоощренияИНаградыШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ВыборкаПоощренияИНаграды.Количество() = 0 Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ПоощренияИНаградыСтрока");
			ТабличныйДокумент.Вывести(ОбластьМакета);	
		КонецЕсли;
		
		Пока ВыборкаПоощренияИНаграды.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ПоощренияИНаградыСтрока");
			ОбластьМакета.Параметры.Заполнить(ВыборкаПоощренияИНаграды);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Отпуск
		ВыборкаОтпуск = МассивРезультатов[10].Выбрать();
		
		ОбластьМакета = Макет.ПолучитьОбласть("ОтпускШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ВыборкаОтпуск.Количество() = 0 Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ОтпускСтрока");
			ТабличныйДокумент.Вывести(ОбластьМакета);	
		КонецЕсли;
		
		Пока ВыборкаОтпуск.Следующий() Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("ОтпускСтрока");
			ОбластьМакета.Параметры.Заполнить(ВыборкаОтпуск);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Социальные льготы и дополнительные сведения
		ОбластьМакета = Макет.ПолучитьОбласть("СоциальныеЛьготыИДопСведения");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Увольнение
		ТаблицаУвольнение = МассивРезультатов[11].Выгрузить();
		
		КоличествоСтрокУвольнения = ТаблицаУвольнение.Количество();
		ОбластьМакета = Макет.ПолучитьОбласть("Увольнение");
		
		Если КоличествоСтрокУвольнения > 0 Тогда
			ОбластьМакета.Параметры.Заполнить(ТаблицаУвольнение[КоличествоСтрокУвольнения - 1]);
		КонецЕсли;	
		
		ТабличныйДокумент.Вывести(ОбластьМакета);		
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПечати") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"НапечататьПомощникСозданияФаксимилеПечати",
			НСтр("ru='Как быстро и просто создать факсимиле подписи?'"),
			СформироватьПомощникРаботыФаксимильнойПечати(МассивОбъектов, ОбъектыПечати, "ПомощникСозданияФаксимилеПодписи"));		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЛичнаяКарточкаСотрудника") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЛичнаяКарточкаСотрудника",
		НСтр("ru = 'Личная карточка сотрудника'"),
		НапечататьКарточку(МассивОбъектов, ОбъектыПечати, "ПФ_XML_ЛичнаяКарточка"));
	КонецЕсли;
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЛичнаяКарточкаСотрудника";
	КомандаПечати.Представление = НСтр("ru = 'Личная карточка сотрудника'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1; 
КонецПроцедуры

#КонецОбласти

#КонецЕсли
