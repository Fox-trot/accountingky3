﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Выводит информационные ссылки на форме
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//	ПутьКФорме - Строка - полный путь к форме.
//
Процедура ВывестиКонтекстныеСсылки(Форма, ГруппаФормы, КоличествоГрупп = 3, КоличествоСсылокВГруппе = 1, ВыводитьСсылкуВсе = Истина, ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылокФормы = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылокФормы.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		// Добавление списка Информационных ссылок
		ИмяРеквизита = "ИнформационныеСсылки";
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		СформироватьГруппыВывода(Форма, ТаблицаСсылокФормы, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе);
		
	Исключение
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Заполняет элементы формы информационными ссылками.
//
// Параметры:
//  Форма - УправляемаяФорма - форма.
//  МассивЭлементов - Массив - массив элементов.
//  ЭлементВсеСсылки - Декорация - элемент формы.
//  ПутьКФорме - Строка - путь к форме.
//
Процедура ЗаполнитьСтатическиеИнформационныеСсылки(Форма, МассивЭлементов, ЭлементВсеСсылки = Неопределено, ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылок = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылок.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки);
		
		Если ТипЗнч(ЭлементВсеСсылки) = Тип("ДекорацияТекстФормы") Тогда
			ОтображатьСсылку = ТаблицаСсылок.Количество() <= МассивЭлементов.Количество();
			ЭлементВсеСсылки.Видимость = ЭлементВсеСсылки;
		КонецЕсли;
		
		
	Исключение
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Возвращает информационную ссылку по идентификатору.
//
// Параметры:
//	Идентификатор - Строка - идентификатор ссылки.
//
// Возвращаемое значение:
//	Структура - контекстная ссылка.
//
Функция КонтекстнаяСсылкаПоИдентификатору(Идентификатор) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("Адрес", "");
	ВозвращаемаяСтруктура.Вставить("Наименование", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Адрес КАК Адрес,
	|	ИнформационныеСсылкиДляФорм.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.Идентификатор = &Идентификатор
	|	И НЕ ИнформационныеСсылкиДляФорм.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВозвращаемаяСтруктура.Адрес = Выборка.Адрес;
		ВозвращаемаяСтруктура.Наименование = Выборка.Наименование;
		Прервать;
		
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Возвращает все пространства имен информационных ссылок.
//
// Возвращаемое значение:
//  Массив - массив пространства имен информационных ссылок.
//
Функция ПространстваИменИнформационныхСсылок() Экспорт
	
	МассивПространств = Новый Массив;
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок());
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок_1_0_1_1());
	
	Возврат МассивПространств;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список макетов для информационных ссылок.
//
// Возвращаемое значение:
//  Массив - массив общих макетов.
//
Функция ПолучитьОбщиеМакетыИнформационныхСсылок() Экспорт
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить(ПолучитьОбщийМакет("ИнформационныеСсылки_Общие"));
	
	ИнформационныйЦентрСерверПереопределяемый.ОбщиеМакетыСИнформационнымиСсылками(МассивМакетов);
	
	Возврат МассивМакетов;
	
КонецФункции

// Формирует хеш полного пути к форме при записи.
//
Процедура ПолныйПутьКФормеПередЗаписьюПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Источник.ПолныйПутьКФорме) Тогда 
		Источник.Хеш = ХешПолногоПутиКФорме(Источник.ПолныйПутьКФорме);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает хеш полного пути к форме по алгоритму.
//
// Параметры:
//	ПолныйПутьКФорме - Строка - полный путь к форме.
//
// Возвращаемое значение:
//	Строка - хэш.
//
Функция ХешПолногоПутиКФорме(Знач ПолныйПутьКФорме) Экспорт
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ПолныйПутьКФорме);
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Возвращает Истину, если установлена интеграция со службой поддержки.
//
Функция УстановленаИнтеграцияСоСлужбойПоддержки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Не ПустаяСтрока(Константы.АдресПрограммногоИнтерфейсаСлужбыПоддержки.Получить());
	
КонецФункции

// Возвращает имя события журнала регистрации.
//
// Возвращаемое значение:
//	Строка - имя события журнала регистрации.
//
Функция ПолучитьИмяСобытияДляЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Информационный центр'", ИнтеграцияПодсистемБТС.КодОсновногоЯзыка());
	
КонецФункции

// Получить прокси управления конференцией.
//
// Возвращаемое значение:
//  WSПрокси - прокси управления конференцией.
//
Функция ПолучитьПроксиУправленияКонференцией() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Адрес = Константы.АдресУправленияКонференцией.Получить() + "/ForumService?wsdl";
	Владелец = ИнтеграцияПодсистемБТС.ИдентификаторОбъектаМетаданных("Константа.АдресУправленияКонференцией");
	Логин = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
	Пароль = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ИнтеграцияПодсистемБТС.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = Адрес;
	ПараметрыПодключения.URIПространстваИмен = "http://ws.forum.saas.onec.ru/";
	ПараметрыПодключения.ИмяСервиса = "ForumIntegrationWSImplService";
	ПараметрыПодключения.ИмяТочкиПодключения = "ForumIntegrationWSImplPort";
	ПараметрыПодключения.ИмяПользователя = Логин;
	ПараметрыПодключения.Пароль = Пароль;
	
	Прокси = ИнтеграцияПодсистемБТС.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_1() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'"));
	КонецЕсли;
	
	АдресСервиса       = АдресМенеджераСервиса + "/ws/ManageInfoCenter_1_0_1_1?wsdl";
	ИмяПользователя    = РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	ПарольПользователя = РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ИнтеграцияПодсистемБТС.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/SaaS/1.0/WS";
	ПараметрыПодключения.ИмяСервиса = "ManageInfoCenter_1_0_1_1";
	ПараметрыПодключения.ИмяТочкиПодключения = "ManageInfoCenter_1_0_1_1Soap";
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = ПарольПользователя;
	ПараметрыПодключения.Таймаут = 7;
	
	Прокси = ИнтеграцияПодсистемБТС.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Центр идей

// Возвращает Прокси Информационного центра Менеджера сервиса.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиЦентраИдей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	АдресМенеджераСервиса = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
	Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
		ВызватьИсключение(НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'"));
	КонецЕсли;
	
    Если Не УстановленаИнтеграцияСЦентромИдейУСП() Тогда
    	АдресСервиса       = АдресМенеджераСервиса + "/ws/UsersIdeas_1_0_0_1?wsdl";
    	ИмяПользователя    = РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
    	ПарольПользователя = РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
    Иначе
    	АдресСервиса       = Константы.АдресСервисаЦентраИдей.Получить();
        Владелец = ИнтеграцияПодсистемБТС.ИдентификаторОбъектаМетаданных("Константа.АдресСервисаЦентраИдей");
    	ИмяПользователя = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
    	ПарольПользователя = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
    КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ИнтеграцияПодсистемБТС.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/1cFresh/InformationCenter/UsersIdeas/1.0.0.1";
	ПараметрыПодключения.ИмяСервиса = "UsersIdeas_1_0_0_1";
	ПараметрыПодключения.ИмяТочкиПодключения = "UsersIdeas_1_0_0_1Soap";
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = ПарольПользователя;
	ПараметрыПодключения.Таймаут = 20;
	
	Прокси = ИнтеграцияПодсистемБТС.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

// Процедура регламентного задания ЧтениеНовостейСлужбыПоддержки
//
Процедура ЧтениеНовостейСлужбыПоддержки() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЧтениеНовостейСлужбыПоддержки);
    
    Если Не ЗначениеЗаполнено(Константы.АдресСервисаНовостей.Получить()) Тогда
        Возврат;
    КонецЕсли;
    
    УстановитьПривилегированныйРежим(Истина);
    
    ПрефиксСервиса = Константы.ПрефиксСервисаДляНовостей.Получить();
    ИмяКонфигурации = Метаданные.Имя;
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ ПЕРВЫЕ 1
        |   ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности КАК ДатаНачалаАктуальности
        |ИЗ
        |   Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
        |ГДЕ
        |   ОбщиеДанныеИнформационногоЦентра.ТипИнформации = &УведомлениеОПожелании
        |   ИЛИ ОбщиеДанныеИнформационногоЦентра.ТипИнформации = &Новость
        |
        |УПОРЯДОЧИТЬ ПО
        |   ДатаНачалаАктуальности УБЫВ";
    
    Запрос.УстановитьПараметр("УведомлениеОПожелании", ОпределитьСсылкуТипаИнформации("УведомлениеОПожелании"));
    Запрос.УстановитьПараметр("Новость", ОпределитьСсылкуТипаИнформации("Новость"));
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Если Выборка.Следующий() Тогда
        ДатаНачала = Выборка.ДатаНачалаАктуальности;
    Иначе
        ДатаНачала = '00010101000000';
    КонецЕсли;
     
    Прокси = ПолучитьПроксиНовостейСлужбыПоддержки();
    Ответ = Прокси.getNews(ПрефиксСервиса, ИмяКонфигурации, ДатаНачала);
    
    Для каждого НовостьXDTO Из Ответ.news Цикл
        
        Идентификатор = Новый УникальныйИдентификатор(НовостьXDTO.id);
        
        Если ЗначениеЗаполнено(Идентификатор) Тогда
            ТипИнформации = ОпределитьСсылкуТипаИнформации("УведомлениеОПожелании");
        Иначе
            ТипИнформации = ОпределитьСсылкуТипаИнформации("Новость");
            Идентификатор = Новый УникальныйИдентификатор();
        КонецЕсли;    
        
        Новость                           = Справочники.ОбщиеДанныеИнформационногоЦентра.СоздатьЭлемент();
    	Новость.Идентификатор             = Идентификатор;
    	Новость.Наименование              = НовостьXDTO.name;
    	Новость.ДатаНачалаАктуальности    = НовостьXDTO.startDate;
    	Новость.ДатаОкончанияАктуальности = НовостьXDTO.endDate;
    	Новость.ТипИнформации             = ТипИнформации;
    	Новость.Критичность               = НовостьXDTO.criticality;
        Новость.ТекстHTML                 = НовостьXDTO.textHTML.htmlText;
        
        Если НовостьXDTO.textHTML.Свойства().Получить("images") <> Неопределено Тогда
            Картинки = Новый Структура;
            Если ТипЗнч(НовостьXDTO.textHTML.images) = Тип("ОбъектXDTO") Тогда
                Картинки.Вставить(НовостьXDTO.textHTML.images.name, Новый Картинка(XMLЗначение(Тип("ДвоичныеДанные"), НовостьXDTO.textHTML.images.data), Истина));
            Иначе
                Для каждого КартинкаXDTO Из НовостьXDTO.textHTML.images Цикл
                    Картинки.Вставить(КартинкаXDTO.name, Новый Картинка(XMLЗначение(Тип("ДвоичныеДанные"), КартинкаXDTO.data), Истина));        	
                КонецЦикла;
            КонецЕсли;
            Новость.Вложения = Новый ХранилищеЗначения(Картинки);
        КонецЕсли; 
        
    	Новость.Записать();
        
    КонецЦикла; 
    
    УстановитьПривилегированныйРежим(Ложь);
    
КонецПроцедуры

// Возвращает количество идей на странице.
//
// Возвращаемое значение:
//	Число - количество идей.
//
Функция КоличествоИдейНаСтранице() Экспорт
	
	Возврат 5;
	
КонецФункции

// Возвращает количество комментариев к идее на странице.
//
// Возвращаемое значение:
//	Число - количество комментариев.
//
Функция КоличествоКомментариевКИдееНаСтранице() Экспорт
	
	Возврат 5;
	
КонецФункции

// Возвращает текст исключения при недоступности центра идей.
//
// Возвращаемое значение:
//	Строка - текст исключения.
//
Функция ТекстВыводаИнформацииОбОшибкеВЦентреИдей() Экспорт 
	
	Возврат НСтр("ru = 'Центр идей временно не доступен.
                       |Пожалуйста, повторите попытку позже.'")
	
КонецФункции

// Проголосовать за идею.
//
// Параметры:
//	WSПрокси - WSПрокси - WSПрокси центра идей.
//	ИдентификаторПользователя - Строка - идентификатор пользователя.
//	ИдентификаторИдеи - Строка - идентификатор идеи.
//	Голос - Число - количество голосов.
//
Процедура ПроголосоватьЗаИдею(Знач WSПрокси, Знач ИдентификаторПользователя, Знач ИдентификаторИдеи, Знач Голос) Экспорт
	
	WSПрокси.addVote(ИдентификаторИдеи, ИдентификаторПользователя, Голос);
	
КонецПроцедуры

// Устанавливает признак просмотренности идеи.
//
// Параметры:
//	ИдентификаторИдеи - УникальныйИдентификатор - идентификатор идеи.
//
Процедура УстановитьПризнакПросмотраИдеи(Знач ИдентификаторИдеи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторИдеи);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.Идентификатор = &Идентификатор";
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ПросмотренныеДанныеИнформационногоЦентра.СоздатьМенеджерЗаписи();
		Запись.Пользователь = Пользователи.ТекущийПользователь();
		Запись.ДанныеИнформационногоЦентра = Выборка.Ссылка;
		Запись.Просмотрены = Истина;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Возвращает предзаголовок идеи.
//
// Параметры:
//	ПредставлениеИдеи - ОбъектXDTO - идея.
//
// Возвращаемое значение:
//	Строка - предзаголовок идеи.
//
Функция СформироватьПредзаголовокИдеи(Знач ПредставлениеИдеи) Экспорт
	
	Возврат ПредставлениеИдеи.UserName + " (" + Формат(ПредставлениеИдеи.CreateDate, "ДЛФ=DD") + ")";
	
КонецФункции

// Формирует заголовок комментариев.
//
// Параметры:
//	ПредставлениеИдеи - ОбъектXDTO - идея.
//
// Возвращаемое значение:
//	Строка - заголовок комментариев.
//
Функция СформироватьЗаголовокКомментариев(Знач ПредставлениеИдеи) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Комментарии: %1'"), ПредставлениеИдеи.CommentsCount);
	
КонецФункции

// Формирует заголовок даты реализации.
//
// Параметры:
//	ПредставлениеИдеи - ОбъектXDTO - идея.
//
// Возвращаемое значение:
//	Строка - заголовок даты реализации.
//
Функция СформироватьЗаголовокДатыРеализации(Знач ПредставлениеИдеи) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Плановая дата реализации: %1'"), ПредставлениеИдеи.PlanMadeDatePresentation);
	
КонецФункции

// Формирует заголовок даты отклонения.
//
// Параметры:
//	ПредставлениеИдеи - ОбъектXDTO - идея.
//
// Возвращаемое значение:
//	Строка - заголовок даты отклонения.
//
Функция СформироватьДатуОтклонения(Знач ПредставлениеИдеи) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Отклонено: %1'"), Формат(ПредставлениеИдеи.ClosingDate, "ДЛФ=DD"));
	
КонецФункции

// Формирует заголовок даты реализации.
//
// Параметры:
//	ПредставлениеИдеи - ОбъектXDTO - идея.
//
// Возвращаемое значение:
//	Строка - заголовок даты реализации.
//
Функция СформироватьДатуРеализации(Знач ПредставлениеИдеи) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Реализовано: %1'"), Формат(ПредставлениеИдеи.ClosingDate, "ДЛФ=DD"));
	
КонецФункции

// Формирует предзаголовок комментария.
//
// Параметры:
//	ПредставлениеКомментария - ОбъектXDTO - комментарий.
//
// Возвращаемое значение:
//	Строка - предзаголовок комментария.
//
Функция СформироватьПредзаголовокКомментария(Знач ПредставлениеКомментария) Экспорт
	
	Возврат ПредставлениеКомментария.UserName + " (" + Формат(ПредставлениеКомментария.Date, "ДЛФ=DD") + " " + Формат(ПредставлениеКомментария.Date, "ДФ=ЧЧ:мм") + ")";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обращения в службу поддержки

// Получает WSПрокси службы поддержки
//
// Возвращаемое значение:
//	WSПрокси - WSПрокси службы поддержки.
//
Функция ПолучитьПроксиСлужбыПоддержки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = Константы.АдресПрограммногоИнтерфейсаСлужбыПоддержки.Получить();
	Владелец = ИнтеграцияПодсистемБТС.ИдентификаторОбъектаМетаданных("Константа.АдресПрограммногоИнтерфейсаСлужбыПоддержки");
	Логин = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
	Пароль = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ИнтеграцияПодсистемБТС.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1";
	ПараметрыПодключения.ИмяСервиса = "InformationCenterIntegration_1_0_0_1";
	ПараметрыПодключения.ИмяТочкиПодключения = "InformationCenterIntegration_1_0_0_1Soap";
	ПараметрыПодключения.ИмяПользователя = Логин;
	ПараметрыПодключения.Пароль = Пароль;
	ПараметрыПодключения.Таймаут = 20;
	
	Прокси = ИнтеграцияПодсистемБТС.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

// Текст исключения при недоступности службы поддержки.
//
// Возвращаемое значение:
//	Строка - текст исключения.
//
Функция ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки() Экспорт
	
	Возврат НСтр("ru = 'Служба поддержки временно не доступна.
                       |Пожалуйста, повторите попытку позже.'")
	
КонецФункции

// Возвращает картинку по состоянию обращения.
//
// Параметры:
//	Состояние - Строка - состояние обращения.
//
// Возвращаемое значение:
//	Картинка - картинка.
//
Функция КартинкаПоСостояниюОбращения(Состояние) Экспорт 
	
	Если Состояние = "Closed" Тогда 
		Возврат БиблиотекаКартинок.ЗакрытоеОбращение;
	ИначеЕсли Состояние = "InProgress" Тогда
		Возврат БиблиотекаКартинок.ОбращениеВРаботе;
	ИначеЕсли Состояние = "New" Тогда
		Возврат БиблиотекаКартинок.НовоеОбращение;
	ИначеЕсли Состояние = "NeedAnswer" Тогда
		Возврат БиблиотекаКартинок.ОбращениеНуженОтвет;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Номер картинки по типу взаимодействия.
//
// Параметры:
//	ТипВзаимодействия - Строка - тип взаимодействия.
//	Входящее - Булево - является ли взаимодействие входящим для пользователя.
//
// Возвращаемое значение:
//	Число - номер картинки.
//
Функция НомерКартинкиПоВзаимодействию(ТипВзаимодействия, Входящее) Экспорт
	
	Если ТипВзаимодействия = "Email" Тогда 
		Если Входящее Тогда 
			Возврат 2;
		Иначе
			Возврат 3;
		КонецЕсли;
	ИначеЕсли ТипВзаимодействия = "Comment" Тогда 
		Возврат 4;
	ИначеЕсли ТипВзаимодействия = "PhoneCall" Тогда 
		Возврат 1;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Возвращает адрес электронной почты текущего пользователя.
//
// Возвращаемое значение:
//	Строка - адрес электронной почты текущего пользователя.
//
Функция ОпределитьАдресЭлектроннойПочтыПользователя() Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда 
		
		Модуль = ИнтеграцияПодсистемБТС.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		Если Модуль = Неопределено Тогда 
			Возврат "";
		КонецЕсли;
		
		Возврат Модуль.КонтактнаяИнформацияОбъекта(ТекущийПользователь, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Оповещения пользователей в форме Информационного центра

// Возвращает ссылку на элемент справочника "ТипыИнформацииИнформационногоЦентра" по Наименованию.
//
// Параметры:
//	Наименование - Строка - наименования типа новости.
//
// Возвращаемое значение:
//	СправочникСсылка.ТипыИнформацииИнформационногоЦентра - тип информации.
//
Функция ОпределитьСсылкуТипаИнформации(Знач Наименование) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Наименование = СокрЛП(Наименование);
	
	НайденнаяСсылка = Справочники.ТипыИнформацииИнформационногоЦентра.НайтиПоНаименованию(Наименование);
	
	Если НайденнаяСсылка.Пустая() Тогда 
		ТипИнформации = Справочники.ТипыИнформацииИнформационногоЦентра.СоздатьЭлемент();
		ТипИнформации.Наименование = Наименование;
		ТипИнформации.Записать();
		
		Возврат ТипИнформации.Ссылка;
	Иначе
		Возврат НайденнаяСсылка;
	КонецЕсли;
	
КонецФункции

// Определяет список всех новостей.
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//
Функция СформироватьСписокВсехНовостей() Экспорт
	
	ЗапросВсехНовостей = Новый Запрос;
	ЗапросВсехНовостей.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	ЗапросВсехНовостей.УстановитьПараметр("ПустаяДата", '00010101');
	ЗапросВсехНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК Ссылка,
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка.ДатаНачалаАктуальности КАК ДатаНачалаАктуальности
	|ПОМЕСТИТЬ СписокНовостей
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка,
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка.ДатаНачалаАктуальности
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности = &ПустаяДата
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	ДатаНачалаАктуальности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 10
	|	СписокНовостей.Ссылка.Критичность КАК Критичность,
	|	СписокНовостей.Ссылка.Идентификатор КАК Идентификатор,
	|	СписокНовостей.Ссылка.ВнешняяСсылка КАК ВнешняяСсылка,
	|	СписокНовостей.Ссылка.ТипИнформации КАК ТипИнформации,
	|	СписокНовостей.ДатаНачалаАктуальности КАК ДатаНачалаАктуальности,
	|	СписокНовостей.Ссылка.Наименование КАК Наименование,
    |   СписокНовостей.Ссылка КАК Новость
    |ИЗ
	|	СписокНовостей КАК СписокНовостей
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросВсехНовостей.Выполнить().Выгрузить();
	
КонецФункции

// Формирует список новостей.
//
// Параметры:
//	ТаблицаНовостей - ТаблицаЗначений с колонками:
//		Наименование - Строка - заголовок новости.
//		Идентификатор - УникальныйИдентификатор - идентификатор новости.
//		Критичность - Число - критичность новости.
//		ВнешняяСсылка - Строка - адрес внешней ссылки.
//	КоличествоВыводимыхНовостей - Число - Количество выводимых новостей на рабочем столе.
//
Процедура СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей, Знач КоличествоВыводимыхНовостей = 3) Экспорт
	
	КритичныеНовости = СформироватьАктуальныеКритичныеНовости();
	
	КоличествоКритичныхНовостей = ?(КритичныеНовости.Количество() >= КоличествоВыводимыхНовостей, КоличествоВыводимыхНовостей, КритичныеНовости.Количество());
	
	// Добавление новостей в общую таблицу.
	Если КоличествоКритичныхНовостей > 0 Тогда 
		Для Итерация = 0 По КоличествоКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, КритичныеНовости.Получить(Итерация));
		КонецЦикла;	
	КонецЕсли;
	
	Если КоличествоКритичныхНовостей = КоличествоВыводимыхНовостей Тогда 
		Возврат;
	КонецЕсли;
	
	НеКритичныеНовости = СформироватьАктуальныеНеКритичныеНовости();
	
	КоличествоВыводимыхНеКритичныхНовостей = КоличествоВыводимыхНовостей - КоличествоКритичныхНовостей;
	
	КоличествоВыводимыхНеКритичныхНовостей = ?(НеКритичныеНовости.Количество() < КоличествоВыводимыхНеКритичныхНовостей, НеКритичныеНовости.Количество(), КоличествоВыводимыхНеКритичныхНовостей);
	
	Если НеКритичныеНовости.Количество() > 0 Тогда 
		Для Итерация = 0 По КоличествоВыводимыхНеКритичныхНовостей - 1 Цикл
			Новость = ТаблицаНовостей.Добавить();
			ЗаполнитьЗначенияСвойств(Новость, НеКритичныеНовости.Получить(Итерация));
		КонецЦикла;
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка сообщений в поддержку сервиса

// Возвращает размер в мегабайтах, размер вложения не больше 20 Мегабайт.
//
// Возвращаемое значение:
//	Число - размер вложений в мегабайтах.
//
Функция МаксимальныйРазмерВложенийДляОтправкиСообщенияВПоддержкуСервиса() Экспорт
	
	Возврат 20;
	
КонецФункции

// Возвращает шаблон текста в техподдержку.
//
// Возвращаемое значение:
//	Строка - шаблон текста в техподдержку.
//
Функция ШаблонТекстаВТехПоддержку() Экспорт
	
	Шаблон = НСтр("ru = 'Здравствуйте.
		|<p/>
		|<p/>ПозицияКурсора
		|<p/>
		|С уважением, %1.'");
	Шаблон = СтрШаблон(Шаблон, Пользователи.ТекущийПользователь().ПолноеНаименование());
	
	Возврат Шаблон;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок()
	
	Возврат "http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/InformationReferences";
	
КонецФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences_1_0_1_1"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок_1_0_1_1()
	
	Возврат "http://www.1c.ru/1cFresh/InformationCenter/InformationReferences/1.0.1.1";
	
КонецФункции

// Возвращает признак использования интеграции с центром идей службы поддержки.
//
Функция УстановленаИнтеграцияСЦентромИдейУСП()
    
    УстановитьПривилегированныйРежим(Истина);
    Возврат Не ПустаяСтрока(Константы.АдресСервисаЦентраИдей.Получить());
    
КонецФункции

// Возвращает Прокси Новостей службы поддержки.
//
// Возвращаемое значение:
//	WSПрокси - прокси Новостей службы поддержки.
//
Функция ПолучитьПроксиНовостейСлужбыПоддержки()
	
	УстановитьПривилегированныйРежим(Истина);
        
  	АдресСервиса       = Константы.АдресСервисаНовостей.Получить();
        
    Владелец = ИнтеграцияПодсистемБТС.ИдентификаторОбъектаМетаданных("Константа.АдресСервисаНовостей");
 	ИмяПользователя = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
  	ПарольПользователя = ИнтеграцияПодсистемБТС.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ИнтеграцияПодсистемБТС.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1cfresh.com/sd/news/1.0";
	ПараметрыПодключения.ИмяСервиса = "News_1_0_1";
	ПараметрыПодключения.ИмяТочкиПодключения = "News_1_0_1Soap";
	ПараметрыПодключения.ИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.Пароль = ПарольПользователя;
	ПараметрыПодключения.Таймаут = 20;
    
	ПроксиНовостей = ИнтеграцияПодсистемБТС.СоздатьWSПрокси(ПараметрыПодключения);
    
    Возврат ПроксиНовостей;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Оповещения пользователей в форме Информационного центра

// Возвращает список актуальных критичных новостей (критичность > 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеКритичныеНовости()
	
	ЗапросКритичныхНовостей = Новый Запрос;
	
	ЗапросКритичныхНовостей.УстановитьПараметр("ТекущаяДата",                ТекущаяДатаСеанса());
	ЗапросКритичныхНовостей.УстановитьПараметр("КритичностьПять",            5);
	ЗапросКритичныхНовостей.УстановитьПараметр("ПустаяДата",                '00010101');
	
	ЗапросКритичныхНовостей.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК СсылкаНаДанные
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность > &КритичностьПять
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбщиеДанныеИнформационногоЦентра.Критичность УБЫВ,
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности УБЫВ";
	
	Возврат ЗапросКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает список актуальных некритичных новостей (критичность <= 5).
//
// Возвращаемое значение:
//	ТаблицаЗначений с полями ТаблицыЗначений "ТаблицаНовостей" в процедуре СформироватьСписокНовостейНаРабочийСтол.
//
Функция СформироватьАктуальныеНеКритичныеНовости()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросНеКритичныхНовостей = Новый Запрос;
	
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ТекущаяДата",     ТекущаяДатаСеанса());
	ЗапросНеКритичныхНовостей.УстановитьПараметр("КритичностьПять", 5);
	ЗапросНеКритичныхНовостей.УстановитьПараметр("ПустаяДата",      '00010101');
	ЗапросНеКритичныхНовостей.УстановитьПараметр("Просмотрены",     Ложь);
	ЗапросНеКритичныхНовостей.УстановитьПараметр("Пользователь",    Пользователи.ТекущийПользователь().Ссылка);
	
	ЗапросНеКритичныхНовостей.Текст =
	"ВЫБРАТЬ
	|	ОбщиеДанныеИнформационногоЦентра.Ссылка КАК СсылкаНаДанные
	|ПОМЕСТИТЬ ДанныеИЦ
	|ИЗ
	|	Справочник.ОбщиеДанныеИнформационногоЦентра КАК ОбщиеДанныеИнформационногоЦентра
	|ГДЕ
	|	ОбщиеДанныеИнформационногоЦентра.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ОбщиеДанныеИнформационногоЦентра.Критичность <= &КритичностьПять
	|	И ОбщиеДанныеИнформационногоЦентра.ДатаОкончанияАктуальности >= &ТекущаяДата
	|	И НЕ ОбщиеДанныеИнформационногоЦентра.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПросмотренныеДанныеИнформационногоЦентра.ДанныеИнформационногоЦентра,
	|	ПросмотренныеДанныеИнформационногоЦентра.Просмотрены
	|ПОМЕСТИТЬ ПросмотренныеПользователем
	|ИЗ
	|	РегистрСведений.ПросмотренныеДанныеИнформационногоЦентра КАК ПросмотренныеДанныеИнформационногоЦентра
	|ГДЕ
	|	ПросмотренныеДанныеИнформационногоЦентра.Пользователь = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеИЦ.СсылкаНаДанные,
	|	ЕСТЬNULL(ПросмотренныеПользователем.Просмотрены, &Просмотрены) КАК Просмотрены
	|ПОМЕСТИТЬ Готовый
	|ИЗ
	|	ДанныеИЦ КАК ДанныеИЦ
	|		ПОЛНОЕ СОЕДИНЕНИЕ ПросмотренныеПользователем КАК ПросмотренныеПользователем
	|		ПО ДанныеИЦ.СсылкаНаДанные = ПросмотренныеПользователем.ДанныеИнформационногоЦентра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Готовый.СсылкаНаДанные
	|ИЗ
	|	Готовый КАК Готовый
	|ГДЕ
	|	Готовый.Просмотрены = &Просмотрены";
	
	Возврат ЗапросНеКритичныхНовостей.Выполнить().Выгрузить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Формирует элементы формы информационных ссылок в группе.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	ГруппаФормы - ЭлементФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура СформироватьГруппыВывода(Форма, ТаблицаСсылок, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе)
	
	КоличествоСсылок = ?(ТаблицаСсылок.Количество() > КоличествоГрупп * КоличествоСсылокВГруппе, КоличествоГрупп * КоличествоСсылокВГруппе, ТаблицаСсылок.Количество());
	
	КоличествоГрупп = ?(КоличествоСсылок < КоличествоГрупп, КоличествоСсылок, КоличествоГрупп);
	
	НеполноеНаименованиеГруппы = "ГруппаИнформационныхСсылок";
	
	Для Итерация = 1 По КоличествоГрупп Цикл 
		
		ИмяЭлементаФормы                            = НеполноеНаименованиеГруппы + Строка(Итерация);
		РодительскаяГруппа                          = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
		РодительскаяГруппа.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
		РодительскаяГруппа.ОтображатьЗаголовок      = Ложь;
		РодительскаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительскаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
		
	КонецЦикла;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ГруппаСсылки = ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, Итерация);
		
		ИмяСсылки      = ТаблицаСсылок.Получить(Итерация - 1).Наименование;
		Адрес          = ТаблицаСсылок.Получить(Итерация - 1).Адрес;
		Подсказка      = ТаблицаСсылок.Получить(Итерация - 1).Подсказка;
		
		ЭлементСсылки                          = Форма.Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаСсылки);
		ЭлементСсылки.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок                = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.АвтоМаксимальнаяШирина   = Ложь;
		ЭлементСсылки.Высота                   = 1;
		ЭлементСсылки.Гиперссылка              = Истина;
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
	Если ВыводитьСсылкуВсе Тогда
		Элемент                         = Форма.Элементы.Добавить("СсылкаВсеИнформационныеСсылки", Тип("ДекорацияФормы"), ГруппаФормы);
		Элемент.Вид                     = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок               = НСтр("ru = 'Все'");
		Элемент.Гиперссылка             = Истина;
		Элемент.ЦветТекста              = WebЦвета.Черный;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки")
	КонецЕсли;
	
КонецПроцедуры

// Заполняет элементы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма.
//  ТаблицаСсылок - ТаблицаЗначений - таблица ссылок.
//  МассивЭлементов - Массив - массив элементов формы.
//  ЭлементВсеСсылки - ДекорацияФормыНадпись, надпись "Все".
//
Процедура ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки)
	
	Для Итерация = 0 По МассивЭлементов.Количество() -1 Цикл
		
		ИмяСсылки = ТаблицаСсылок.Получить(Итерация).Наименование;
		Адрес = ТаблицаСсылок.Получить(Итерация).Адрес;
		Подсказка = ТаблицаСсылок.Получить(Итерация).Подсказка;
		
		ЭлементСсылки = МассивЭлементов.Получить(Итерация);
		ЭлементСсылки.Заголовок = ИмяСсылки;
		ЭлементСсылки.Гиперссылка = Истина;
		ЭлементСсылки.Подсказка = Подсказка;
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает группу, в которой необходимо выводить информационные ссылки.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст формы.
//	КоличествоГрупп - Число - количество групп с информационными ссылками на форме.
//	НеполноеНаименованиеГруппы - Строка - неполное наименование группы.
//	ТекущаяИтерация - Число - текущая итерация.
//
// Возвращаемое значение:
//	ЭлементФормы - группа информационных ссылок или неопределенно.
//
Функция ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, ТекущаяИтерация)
	
	ИмяГруппы = "";
	
	Для ИтерацияГрупп = 1 По КоличествоГрупп Цикл
		
		Если ТекущаяИтерация % ИтерацияГрупп  = 0 Тогда 
			ИмяГруппы = НеполноеНаименованиеГруппы + Строка(ИтерацияГрупп);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Форма.Элементы.Найти(ИмяГруппы);
	
КонецФункции

#КонецОбласти