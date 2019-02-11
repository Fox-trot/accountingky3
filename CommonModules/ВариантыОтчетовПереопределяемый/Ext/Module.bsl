﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает настройки, применяемые как стандартные для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - умолчание для вывода гиперссылок в панели отчетов:
//           Истина - варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           Ложь   - варианты отчетов по умолчанию видимы, а отчеты отключены.
//           Значение по умолчанию: Ложь.
//       * ВыводитьОписания - Булево - умолчание для вывода описаний в панели отчетов:
//           Истина - значение по умолчанию. Выводить описания в виде подписей под гиперссылками вариантов
//           Ложь   - выводить описания в виде всплывающих подсказок
//           Значение по умолчанию: Истина.
//       * Поиск - Структура - настройки поиска вариантов отчетов.
//           ** ПодсказкаВвода - Строка - текст подсказки выводится в поле поиска когда поиск не задан.
//               В качестве примера рекомендуется указывать часто используемые термины прикладной конфигурации.
//       * ДругиеОтчеты - Структура - настройки формы "Другие отчеты":
//           ** ЗакрыватьПослеВыбора - Булево - закрывать ли форму после выбора гиперссылки отчета.
//               Истина - закрывать "Другие отчеты" после выбора.
//               Ложь   - не закрывать.
//               Значение по умолчанию: Истина.
//           ** ПоказыватьФлажок - Булево - показывать ли флажок ЗакрыватьПослеВыбора.
//               Истина - показывать флажок "Закрывать это окно после перехода к другому отчету".
//               Ложь   - не показывать флажок.
//               Значение по умолчанию: Ложь.
//       * РазрешеноИзменятьВарианты - Булево - показывать расширенные настройки отчета
//               и команды изменения варианта отчета.
//
// Пример:
//	Настройки.Поиск.ПодсказкаВвода = НСтр("ru = 'Например, себестоимость'");
//	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
//	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
//	Настройки.РазрешеноИзменятьВарианты = Ложь;
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ВыводитьОтчетыВместоВариантов = Истина;
	Настройки.ВыводитьОписания = Истина;
	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки размещения отчетов

// Определяет разделы глобального командного интерфейса, в которых предусмотрены панели отчетов.
// В Разделы необходимо добавить метаданные тех подсистем первого уровня,
// в которых размещены команды вызова панелей отчетов.
//
// Параметры:
//  Разделы - СписокЗначений - разделы, в которые выведены команды открытия панели отчетов.
//      * Значение - ОбъектМетаданных: Подсистема, Строка - подсистема раздела глобального командного интерфейса,
//                   либо ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы для начальной страницы.
//      * Представление - Строка - заголовок панели отчетов в этом разделе.
//
// Пример:
//	Разделы.Добавить(Метаданные.Подсистемы.Анкетирование, НСтр("ru = 'Отчеты по анкетированию'"));
//	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), НСтр("ru = 'Основные отчеты'"));
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.ДенежныеСредства, НСтр("ru = 'Отчеты по денежным средствам'"));
	Разделы.Добавить(Метаданные.Подсистемы.ПокупкаИПродажа, НСтр("ru = 'Отчеты по покупке и продаже'"));
	Разделы.Добавить(Метаданные.Подсистемы.Запасы, НСтр("ru = 'Отчеты по запасам'"));	
	Разделы.Добавить(Метаданные.Подсистемы.Производство, НСтр("ru = 'Отчеты по производству'"));	
	Разделы.Добавить(Метаданные.Подсистемы.ОсновныеСредства, НСтр("ru = 'Отчеты по основным средствам'"));	
	Разделы.Добавить(Метаданные.Подсистемы.Зарплата, НСтр("ru = 'Отчеты по расчету заработной платы'"));
	Разделы.Добавить(Метаданные.Подсистемы.Руководителю, НСтр("ru = 'Отчеты для руководителя'"));
	
КонецПроцедуры

// Задает настройки размещения вариантов отчетов в панели отчетов.
// Изменяя настройки отчета, можно изменить настройки всех его вариантов.
// Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
// т.е. более не будут наследовать изменения настроек от отчета.
//   
// Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
// ее дублирование в коде не требуется.
//   
// Функциональные опции предопределенного варианта отчета объединяются с функциональными опциями этого отчета по правилам:
// (ФО1_Отчета ИЛИ ФО2_Отчета) И (ФО3_Варианта ИЛИ ФО4_Варианта).
// Для пользовательских вариантов отчета действуют только функциональные опции отчета
// - они отключаются только с отключением всего отчета.
//
// Параметры:
//   Настройки - Коллекция - настройки отчетов и вариантов отчетов конфигурации.
//                           Для их изменения предназначены следующие вспомогательные процедуры и функции:
//                           ВариантыОтчетов.ОписаниеОтчета, 
//                           ВариантыОтчетов.ОписаниеВарианта, 
//                           ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов, 
//                           ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера.
//
// Пример:
//
//  // Добавление варианта отчета в подсистему.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  // Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
//  // Отключение всех вариантов отчета, кроме одного.
//	НастройкиОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	НастройкиОтчета.Включен = Ложь;
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Истина;
//
//  // Заполнение настроек для поиска - наименования полей, параметров и отборов:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru = 'Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru = 'Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  // Переключение режима вывода в панелях отчетов:
//  // Группировка вариантов отчета по этому отчету:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, Истина);
//  // Без группировки по отчету:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, Ложь);
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.НастроитьВариантыОтчетов(Настройки);
	// Конец ИнтернетПоддержкаПользователей

	// Отчеты подсистемы Зарплата
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ШтатноеРасписание);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СписокСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетнаяВедомость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетнаяВедомостьПоВидамРасчета);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетныеЛистки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьНачисленияЗаработнойПлаты);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СправкаОПодоходномНалоге);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СправкаОЗаработнойПлате);
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасходовНаОплатуТруда);
	
	// Отчеты подсистемы Персонал
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КадровыеИзменения);
	
	// Отчеты подсистемы Основные средства
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПоступленияОС); 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПринятияКУчетуОС); 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьСобытийОС); 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьВыбытияОС);
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЖурналОС); 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПеремещенияОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводПоОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтчетОНаличииОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИтоговаяВедомостьПоГруппамОСЗаМесяц);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПередачиОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПоАмортизацииОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотнаяВедомостьОС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПереченьОСНаДатуКомплекты);

	// Отчеты подсистемы ДенежныеСредства
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АвансовыйОтчетЗаМесяц);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводкаПоДенежнымСредствам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасшифровкаСводкиПоДенежнымСредствам);
	
	// Отчеты подсистемы ПокупкаИПродажа
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.МатериальнаяВедомость);	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоТоварам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализНеоплаченныхСчетовПокупателям);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтчетПоПродажам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РеестрПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РеестрЗакупок);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСКонтрагентами);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасшифровкаРасчетовСКонтрагентами);
	
	
	// Отчеты подсистемы СчетаФактуры		 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.УведомлениеОбОстаткеНеиспользованныхСерийИНомеровСчетовФактур);		 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СведенияОВыписанныхСчетахФактурахНДСПоОблагаемымПоставкам);		 
	 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИзмененияОкладовСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводНачисленийИУдержаний);
	
	// Запасы
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПоступленияТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоМБП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьОстатковМБП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КонтрольОтрицательныхОстатков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводПоТоварам);
	
	// Отчеты подсистемы Производство		 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВыпускГотовойПродукции);		 
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасшифровкаЗатратНаПроизводство);		 

	// Стандартные отчеты
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтчетПоПроводкам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотыМеждуСубконто);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводныеПроводки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ШахматнаяВедомость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализСубконто);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализСчета);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КарточкаСчета);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоСчету);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоПарнымСчетам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КарточкаСубконто);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотыСчета);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ГлавнаяКнига);
	
	// Руководителю
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализДвиженийДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализНеоплаченныхСчетовПокупателям);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализНеоплаченныхСчетовПоставщиков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВаловаяПрибыль);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвижениеТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДинамикаЗадолженностиПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДинамикаЗадолженностиПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДоходыРасходы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗадолженностьПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗадолженностьПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборачиваемостьТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотныеСредства);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПоступленияДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Продажи);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПродажиПоМесяцам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасходыДенежныхСредств);
	
КонецПроцедуры

// Регистрирует изменения в именах вариантов отчетов.
// Используется при обновлении в целях сохранения ссылочной целостности,
// в частности для сохранения пользовательских настроек и настроек рассылок отчетов.
// Старое имя варианта резервируется и не может быть использовано в дальнейшем.
// Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
// указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
// Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
// то рекомендуется задавать их таким образом, что бы затем не менять.
// В Изменения необходимо добавить описания изменений имен вариантов
// отчетов, подключенных к подсистеме.
//
// Параметры:
//   Изменения - ТаблицаЗначений - таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - текущее (последнее актуальное) имя варианта.
//
// Пример:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки команд отчетов

// Определяет объекты конфигурации, в модулях менеджеров которых предусмотрена процедура ДобавитьКомандыОтчетов,
// описывающая команды открытия контекстных отчетов.
// Синтаксис процедуры ДобавитьКомандыОтчетов см. в документации.
//
// Параметры:
//  Объекты - Массив - объекты метаданных (ОбъектМетаданных) с командами отчетов.
//
Процедура ОпределитьОбъектыСКомандамиОтчетов(Объекты) Экспорт
	
КонецПроцедуры

// Определение списка глобальных команд отчетов.
// Событие возникает в процессе вызова модуля повторного использования.
//
// Параметры:
//  КомандыОтчетов - ТаблицаЗначений - таблица команд для вывода в подменю. Для изменения.
//       * Идентификатор - Строка - идентификатор команды.
//     
//     Настройки внешнего вида:
//       * Представление - Строка   - представление команды в форме.
//       * Важность      - Строка   - суффикс группы в подменю, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - порядок размещения команды в группе. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - картинка команды.
//       * СочетаниеКлавиш - СочетаниеКлавиш - сочетание клавиш для быстрого вызова команды.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - имена форм через запятую, в которых должна отображаться команда.
//                                        Используется когда состав команд отличается для различных форм.
//       * ФункциональныеОпции - Строка - имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - определяет доступность команды в ситуации,
//                                        когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево, Неопределено - если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию: Истина.
//       * РежимЗаписи - Строка - действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//             ** "НеЗаписывать"          - объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                       вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                       которая передается в структуре 2 параметра обработчика команды.
//             ** "ЗаписыватьТолькоНовые" - записывать новые объекты.
//             ** "Записывать"            - записывать новые и модифицированные объекты.
//             ** "Проводить"             - проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию: "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - если Истина, то в веб-клиенте предлагается
//             установить расширение работы с файлами.
//             Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - полное имя объекта метаданных, отвечающего за выполнение команды.
//             Пример: "Отчет._ДемоКнигаПокупок".
//       * ИмяФормы - Строка - имя формы, которую требуется открыть или получить для выполнения команды.
//             Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * КлючВарианта - Строка - имя варианта отчета, открываемого при выполнении команды.
//       * ИмяПараметраФормы - Строка - имя параметра формы, в который следует передать ссылку или массив ссылок.
//       * ПараметрыФормы - Неопределено, Структура - параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - описание процедуры, обрабатывающей основное действие команды.
//             Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется когда процедура размещена в общем модуле.
//             Формат "<ИмяПроцедуры>" используется в следующих случаях:
//               - Если ИмяФормы заполнено то в модуле указанной формы ожидается клиентская процедура.
//               - Если ИмяФормы не заполнено то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - Структура - параметры обработчика, указанного в Обработчик.
//   
//  Параметры - Структура - сведения о контексте исполнения.
//       * ИмяФормы - Строка - полное имя формы.
//   
//  СтандартнаяОбработка - Булево - если установить в Ложь, то событие "ДобавитьКомандыОтчетов" менеджера объекта не
//                                  будет вызвано.
//
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
