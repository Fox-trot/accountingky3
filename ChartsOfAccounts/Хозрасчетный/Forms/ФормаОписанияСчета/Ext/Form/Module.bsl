﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстОписания = ПолучитьОписаниеСчета(Параметры.Счет);
	ОбновитьЗаголовокФормы(ЭтаФорма, Параметры.Счет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОписанияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Позиция = Найти(ДанныеСобытия.Href, "ОписаниеСчета=");
	Если Позиция > 0 Тогда
		ПредставлениеСчета = Сред(ДанныеСобытия.Href, Позиция + 14);
		Попытка
			ТекстОписания = ПолучитьОписаниеСчета(ПредставлениеСчета);
			ОбновитьЗаголовокФормы(ЭтаФорма, ПредставлениеСчета);
		Исключение
			// Запись в журнал регистрации не требуется
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФормы(Форма, Счет) 
	
	Если ЗначениеЗаполнено(Счет) Тогда
		Форма.Заголовок = СтрШаблон(НСтр("ru = 'Описание счета: %1'"), Счет);
	Иначе
		Форма.Заголовок = НСтр("ru = 'Не указан счет'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОписаниеСчета(Счет) 
	
	ТекстОписания = "";
	
	Если ТипЗнч(Счет) = Тип("Строка") Тогда
		Счет = ЗначениеИзСтрокиВнутр(Счет);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Счет) Тогда
		Возврат ТекстОписания;
	КонецЕсли;
	
	ПланСчетов = ПланыСчетов.Хозрасчетный;
	Макет      = ПланСчетов.ПолучитьМакет("Описание");
	ИмяСчета   = ПланСчетов.ПолучитьИмяПредопределенного(Счет);
	
	Попытка
		Область = Макет.ПолучитьОбласть(ИмяСчета + "|Описание");
	Исключение
		// Запись в журнал регистрации не требуется
		Область = Макет.ПолучитьОбласть("ОписаниеНеЗадано|Описание");
	КонецПопытки;
	
	// Заголовок HTML документа
	ЗаголовокHTMLДокумента = 
	"<HTML>
	|<HEAD>
	|<STYLE>	
	|BODY {	FONT-SIZE: 10pt; FONT-FAMILY: Verdana }
	|H1 { FONT-WEIGHT: bold; FONT-SIZE: 14pt; FONT-FAMILY: Arial, Tahoma; TEXT-ALIGN: left }
	|H2 { FONT-WEIGHT: bold; FONT-SIZE: 12pt; FONT-FAMILY: Arial, Tahoma; TEXT-ALIGN: left }
	|</STYLE>
	|</HEAD>
	|";
	
	// Подвал HTML документа
	ПодвалHTMLДокумента = "
	|</HTML>";
	
	// Заголовок описания
	ЗаголовокОписания = "<h1>Счет " + Счет.Код + "<br>" + Счет.Наименование + "</h1>";
	
	// Список ссылок на описания субсчетов
	СписокСубсчетов = "";
	Выборка = ПланСчетов.Выбрать(Счет);
	Пока Выборка.Следующий() Цикл
		СписокСубсчетов = СписокСубсчетов + ?(ПустаяСтрока(СписокСубсчетов), "<h2>К счету открыты следующие субсчета " + ?(Счет.Уровень() > 0, СокрЛП(Счет.Уровень() + 1) + "-го уровня", "") + ":</h2><ul>", "");
		СписокСубсчетов = СписокСубсчетов + "<li><a href='ОписаниеСчета=" + ЗначениеВСтрокуВнутр(Выборка.Ссылка) + "'>" + Выборка.Код + " """ + Выборка.Наименование + """</a></li>";
	КонецЦикла;
	СписокСубсчетов = СписокСубсчетов +  "</ul>";
	
	// Ссылка на описание счета-родителя
	ОписаниеРодителя = "";
	Если НЕ Счет.Родитель.Пустая() Тогда
		ОписаниеРодителя = "<p><a href='ОписаниеСчета=" + ЗначениеВСтрокуВнутр(Счет.Родитель) + "'>Описание счета " + Счет.Родитель.Код + " """ + Счет.Родитель.Наименование + """</a></p>"
	КонецЕсли;
	
	ТекстОписания = ЗаголовокHTMLДокумента
		+ ЗаголовокОписания 
		+ "<p>" + СтрЗаменить(Область.ТекущаяОбласть.Текст, Символы.ПС, "<p></p>") + "</p>" 
		+ СписокСубсчетов
		+ ОписаниеРодителя
		+ ПодвалHTMLДокумента;
	
	Возврат ТекстОписания;

КонецФункции

#КонецОбласти